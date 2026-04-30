# -*- mode: python ; coding: utf-8 -*-

import os
import sys
from PyInstaller.utils.hooks import collect_dynamic_libs, collect_data_files

# Recolecta todos los .so del Azure Speech SDK
azure_binaries = collect_dynamic_libs('azure.cognitiveservices.speech')
azure_datas    = collect_data_files('azure.cognitiveservices.speech')

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=azure_binaries,
    datas=azure_datas,
    hiddenimports=[
        'azure.cognitiveservices.speech',
        'azure.cognitiveservices.speech.audio',
        'azure.cognitiveservices.speech.dialog',
        'azure.cognitiveservices.speech.intent',
        'azure.cognitiveservices.speech.translation',
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)

pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='main',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,          # UPX puede corromper .so en Linux, mejor desactivado
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
