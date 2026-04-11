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

def debug_print(msg: str):
    sys.stderr.write(f"[Python Debug] {msg}\n")
    sys.stderr.flush()

class PronunciationAssessmentService:

    def __init__(self, subscription_key: str, endpoint: str):
        debug_print(f"Initializing PronunciationAssessmentService with endpoint: {endpoint}")
        self._speech_config = speechsdk.SpeechConfig(
            subscription=subscription_key,
            endpoint=endpoint,
        )
        self._speech_config.request_word_level_timestamps()
        debug_print("SpeechConfig created successfully.")

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
        debug_print(f"Starting assess() with {len(wav_bytes)} bytes of audio data")
        debug_print(f"Config: lang={language}, rate={sample_rate}, ref_text='{reference_text}'")

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
        debug_print("Audio stream format created")

        push_stream = speechsdk.audio.PushAudioInputStream(stream_format=audio_format)
        push_stream.write(wav_bytes)
        push_stream.close()
        debug_print("Wav bytes written to push_stream")

        self._speech_config.speech_recognition_language = language

        recognizer = speechsdk.SpeechRecognizer(
            speech_config=self._speech_config,
            audio_config=speechsdk.AudioConfig(stream=push_stream),
        )
        pronunciation_config.apply_to(recognizer)
        debug_print("Recognizer configured. Calling recognize_once()...")

        result = recognizer.recognize_once()
        debug_print(f"recognize_once() returned with reason: {result.reason}")

        if result.reason == speechsdk.ResultReason.RecognizedSpeech:
            raw_json = result.properties.get(speechsdk.PropertyId.SpeechServiceResponse_JsonResult)
            debug_print(f"Raw JSON result available: {bool(raw_json)}")
            if not raw_json:
                return {"success": False, "error_code": "INTERNAL_ERROR", "message": "No JSON result in response"}
            
            parsed = json.loads(raw_json)
            if not ("NBest" in parsed and isinstance(parsed["NBest"], list) and parsed["NBest"]):
                return {"success": False, "error_code": "INTERNAL_ERROR", "message": "Invalid or incomplete response from Azure"}
            
            debug_print("Successfully parsed response")
            return {"success": True, "data": parsed}

        elif result.reason == speechsdk.ResultReason.NoMatch:
            debug_print(f"No match details: {result.no_match_details}")
            return {"success": False, "error_code": "NO_SPEECH", "message": str(result.no_match_details)}

        elif result.reason == speechsdk.ResultReason.Canceled:
            details = result.cancellation_details
            debug_print(f"Canceled reason: {details.reason}, error details: {details.error_details}")
            
            error_code = "UNKNOWN_ERROR"
            if details.reason == speechsdk.CancellationReason.Error:
                if "401" in details.error_details or "403" in details.error_details or "Authentication" in details.error_details:
                    error_code = "AUTH_ERROR"
                elif "429" in details.error_details or "TooManyRequests" in details.error_details:
                    error_code = "QUOTA_ERROR"
                elif "DNS" in details.error_details or "Connection" in details.error_details or "WebSocket" in details.error_details:
                    error_code = "NETWORK_ERROR"
            
            return {"success": False, "error_code": error_code, "message": details.error_details}

        return {"success": False, "error_code": "UNKNOWN_ERROR", "message": f"Unexpected result: {result.reason}"}


if __name__ == "__main__":
    sys.stdin.reconfigure(line_buffering=True)
    sys.stdout.reconfigure(line_buffering=True)

    debug_print("Starting Python script...")

    try:
        service = PronunciationAssessmentService(
            subscription_key=os.environ["SPEECH_KEY"],
            endpoint=os.environ["SPEECH_ENDPOINT"],
        )
    except KeyError as e:
        debug_print(f"Missing environment variable: {e}")
        print(json.dumps({"success": False, "error_code": "AUTH_ERROR", "message": f"Missing environment variable: {e}"}), flush=True)
        sys.exit(1)
    except Exception as e:
        debug_print(f"Initialization error: {e}")
        print(json.dumps({"success": False, "error_code": "INTERNAL_ERROR", "message": f"Initialization error: {e}"}), flush=True)
        sys.exit(1)

    debug_print("Service initialized, listening on stdin...")

    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            debug_print(f"Received request line of length: {len(line)}")
            req = json.loads(line)
            debug_print("JSON request parsed.")
            
            wav_bytes = base64.b64decode(req["audio_base64"])
            result = service.assess(
                wav_bytes=wav_bytes,
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
            print(json.dumps(result), flush=True)
        except Exception as e:
            debug_print(f"Error processing request: {e}")
            print(json.dumps({"success": False, "error_code": "INTERNAL_ERROR", "message": str(e)}), flush=True)