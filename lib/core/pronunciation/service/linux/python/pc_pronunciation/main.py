import os
import sys

# Ensure dynamic libraries are found for Azure Speech SDK
if getattr(sys, 'frozen', False):
    meipass = sys._MEIPASS
    speech_lib_dir = os.path.join(meipass, 'azure', 'cognitiveservices', 'speech')
    existing = os.environ.get('LD_LIBRARY_PATH', '')
    os.environ['LD_LIBRARY_PATH'] = f"{speech_lib_dir}:{existing}" if existing else speech_lib_dir

    import ctypes
    try:
        ctypes.CDLL(os.path.join(speech_lib_dir, 'libMicrosoft.CognitiveServices.Speech.core.so'))
    except OSError as e:
        sys.stderr.write(f"Error loading libMicrosoft.CognitiveServices.Speech.core.so: {e}\n")
        # Proceed anyway, SpeechConfig might fail later if it's truly missing

import json
import base64
import azure.cognitiveservices.speech as speechsdk


class PronunciationAssessmentService:

    def __init__(self, subscription_key: str, endpoint: str):
        self._speech_config = speechsdk.SpeechConfig(
            subscription=subscription_key,
            endpoint=endpoint,
        )
        self._speech_config.request_word_level_timestamps()

    def assess(
        self,
        wav_bytes: bytes,
        language: str,
        sample_rate: int = 16000,
        bits_per_sample: int = 16,
        channels: int = 1,
        reference_text: str = '',
        grading_system: str = 'HundredMark',
        granularity: str = 'Phoneme',
        phoneme_alphabet: str = 'IPA',
        n_best_phoneme_count: int = 5,
        enable_miscue: bool = False,
        enable_prosody_assessment: bool = False,
    ) -> dict:
        pronunciation_config = speechsdk.PronunciationAssessmentConfig(
            json_string=json.dumps({
                'referenceText': reference_text,
                'gradingSystem': grading_system,
                'granularity': granularity,
                'phonemeAlphabet': phoneme_alphabet,
                'nBestPhonemeCount': n_best_phoneme_count,
                'enableMiscue': enable_miscue,
            })
        )

        if enable_prosody_assessment:
            pronunciation_config.enable_prosody_assessment()

        audio_format = speechsdk.audio.AudioStreamFormat(
            samples_per_second=sample_rate,
            bits_per_sample=bits_per_sample,
            channels=channels,
        )
        push_stream = speechsdk.audio.PushAudioInputStream(stream_format=audio_format)
        push_stream.write(wav_bytes)
        push_stream.close()

        self._speech_config.speech_recognition_language = language

        recognizer = speechsdk.SpeechRecognizer(
            speech_config=self._speech_config,
            audio_config=speechsdk.AudioConfig(stream=push_stream),
        )
        pronunciation_config.apply_to(recognizer)

        result = recognizer.recognize_once()

        if result.reason == speechsdk.ResultReason.RecognizedSpeech:
            raw_json = result.properties.get(speechsdk.PropertyId.SpeechServiceResponse_JsonResult)
            if not raw_json:
                raise RuntimeError("No JSON result in response")
            parsed = json.loads(raw_json)
            if not ("NBest" in parsed and isinstance(parsed["NBest"], list) and parsed["NBest"]):
                raise RuntimeError("Invalid or incomplete response")
            return parsed

        elif result.reason == speechsdk.ResultReason.NoMatch:
            raise RuntimeError(f"No speech recognized: {result.no_match_details}")

        elif result.reason == speechsdk.ResultReason.Canceled:
            details = speechsdk.CancellationDetails.from_result(result)
            raise RuntimeError(f"Canceled: {details.reason} | {details.error_details}")

        raise RuntimeError(f"Unexpected result: {result.reason}")


if __name__ == "__main__":
    sys.stdin.reconfigure(line_buffering=True)
    sys.stdout.reconfigure(line_buffering=True)

    try:
        service = PronunciationAssessmentService(
            subscription_key=os.environ["SPEECH_KEY"],
            endpoint=os.environ["SPEECH_ENDPOINT"],
        )
    except KeyError as e:
        print(json.dumps({"success": False, "error": f"Missing environment variable: {e}"}), flush=True)
        sys.exit(1)
    except Exception as e:
        print(json.dumps({"success": False, "error": f"Initialization error: {e}"}), flush=True)
        sys.exit(1)

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
            result = service.assess(
                wav_bytes=base64.b64decode(req["audio_base64"]),
                language=req["language"],
                sample_rate=req.get("sample_rate", 16000),
                bits_per_sample=req.get("bits_per_sample", 16),
                channels=req.get("channels", 1),
                reference_text=req.get("reference_text", ""),
                grading_system=req.get("grading_system", "HundredMark"),
                granularity=req.get("granularity", "Phoneme"),
                phoneme_alphabet=req.get("phoneme_alphabet", "IPA"),
                n_best_phoneme_count=req.get("n_best_phoneme_count", 5),
                enable_miscue=req.get("enable_miscue", False),
                enable_prosody_assessment=req.get("enable_prosody_assessment", False),
            )
            print(json.dumps({"success": True, "data": result}), flush=True)
        except Exception as e:
            print(json.dumps({"success": False, "error": str(e)}), flush=True)
