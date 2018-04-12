package com.diego.afinador;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;

public class Audio {

    private final AudioRecord recorder;

    // Audio Recorder config
    private static final int AUDIO_SAMPLE_RATE = 44100;
    private static final int AUDIO_RECORD_AUDIO_FORMAT = AudioFormat.ENCODING_PCM_FLOAT;
    private static final int AUDIO_RECORD_CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO;
    private static final int AUDIO_RECORD_BUFFER_SIZE = AudioRecord.getMinBufferSize(AUDIO_SAMPLE_RATE,
            AUDIO_RECORD_CHANNEL_CONFIG,AUDIO_RECORD_AUDIO_FORMAT);
    private static final int AUDIO_RECORD_READ_SIZE = AUDIO_RECORD_BUFFER_SIZE / 4;
    private static final int AUDIO_RECORD_AUDIO_SOURCE = MediaRecorder.AudioSource.MIC;

    private final float[] floatBuffer = new float[AUDIO_RECORD_READ_SIZE];


    Audio() {
        recorder = new AudioRecord(AUDIO_RECORD_AUDIO_SOURCE, AUDIO_SAMPLE_RATE,
                AUDIO_RECORD_CHANNEL_CONFIG, AUDIO_RECORD_AUDIO_FORMAT, AUDIO_RECORD_BUFFER_SIZE);
    }

    public void startRecording() { recorder.startRecording(); }

    public void stopRecording() {
        recorder.stop();
    }

    public float[] readNext() {
        recorder.read(floatBuffer, 0, AUDIO_RECORD_READ_SIZE, AudioRecord.READ_BLOCKING);
        return floatBuffer;
    }

    public static int getSampleRate() { return AUDIO_SAMPLE_RATE; }

    public static int getReadSize() { return AUDIO_RECORD_READ_SIZE; }

}