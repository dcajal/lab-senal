package com.diego.afinador;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.util.Locale;


public class SelectFrequency extends AppCompatActivity implements  View.OnClickListener{
    // According to the YIN Paper, the threshold should be between 0.10 and 0.15
    private static final float ABSOLUTE_THRESHOLD = 0.125f;

    private float[] diffBuffer = new float[Audio.getReadSize() / 2];
    private final int length = diffBuffer.length;
    private int count = 1;
    private double sum = 0;
    private double freqReq;
    private boolean diff = false;
    private boolean threadStarted = false;
    private TextView noteDisplay;
    private TextView diffDisplay;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_frecuency);
        noteDisplay = (TextView) findViewById(R.id.note_display);
        diffDisplay = (TextView) findViewById(R.id.diff_display);

        Button buttonDo, buttonDos,buttonRe, buttonRes, buttonMi, buttonFa, buttonFas,
                buttonSol, buttonSols, buttonLa, buttonLas, buttonSi;

        buttonDo = findViewById(R.id.buttonDo);
        buttonDo.setOnClickListener(this);
        buttonDos = findViewById(R.id.buttonDos);
        buttonDos.setOnClickListener(this);
        buttonRe = findViewById(R.id.buttonRe);
        buttonRe.setOnClickListener(this);
        buttonRes = findViewById(R.id.buttonRes);
        buttonRes.setOnClickListener(this);
        buttonMi = findViewById(R.id.buttonMi);
        buttonMi.setOnClickListener(this);
        buttonFa = findViewById(R.id.buttonFa);
        buttonFa.setOnClickListener(this);
        buttonFas = findViewById(R.id.buttonFas);
        buttonFas.setOnClickListener(this);
        buttonSol = findViewById(R.id.buttonSol);
        buttonSol.setOnClickListener(this);
        buttonSols = findViewById(R.id.buttonSols);
        buttonSols.setOnClickListener(this);
        buttonLa = findViewById(R.id.buttonLa);
        buttonLa.setOnClickListener(this);
        buttonLas = findViewById(R.id.buttonLas);
        buttonLas.setOnClickListener(this);
        buttonSi = findViewById(R.id.buttonSi);
        buttonSi.setOnClickListener(this);
    }

    @Override
    public void onClick(View view) {
        String noteReq = "";
        switch (view.getId()) {
            case R.id.buttonDo:
                freqReq = Notes.notesFreq[0];
                noteReq = Notes.notesName[0];
                break;
            case R.id.buttonDos:
                freqReq = Notes.notesFreq[1];
                noteReq = Notes.notesName[1];
                break;
            case R.id.buttonRe:
                freqReq = Notes.notesFreq[2];
                noteReq = Notes.notesName[2];
                break;
            case R.id.buttonRes:
                freqReq = Notes.notesFreq[3];
                noteReq = Notes.notesName[3];
                break;
            case R.id.buttonMi:
                freqReq = Notes.notesFreq[4];
                noteReq = Notes.notesName[4];
                break;
            case R.id.buttonFa:
                freqReq = Notes.notesFreq[5];
                noteReq = Notes.notesName[5];
                break;
            case R.id.buttonFas:
                freqReq = Notes.notesFreq[6];
                noteReq = Notes.notesName[6];
                break;
            case R.id.buttonSol:
                freqReq = Notes.notesFreq[7];
                noteReq = Notes.notesName[7];
                break;
            case R.id.buttonSols:
                freqReq = Notes.notesFreq[8];
                noteReq = Notes.notesName[8];
                break;
            case R.id.buttonLa:
                freqReq = Notes.notesFreq[9];
                noteReq = Notes.notesName[9];
                break;
            case R.id.buttonLas:
                freqReq = Notes.notesFreq[10];
                noteReq = Notes.notesName[10];
                break;
            case R.id.buttonSi:
                freqReq = Notes.notesFreq[11];
                noteReq = Notes.notesName[11];
                break;
        }

        noteDisplay.setText(noteReq);

        if (!threadStarted) {
            Thread t = new Thread(detectionThread);
            t.start();
            threadStarted = true;
        }
    }


    public void updateTextView(double diff) {
        String display = String.format(Locale.ENGLISH, "%.2f Hz", diff);
        diffDisplay.setText(display);
    }

    public void updateTextView(String text) {
        diffDisplay.setText(text);
    }


    private Runnable detectionThread = new Runnable() {
        Audio rec = new Audio();
        double pitch = 0;
        double energy;

        @Override
        public void run() {
            rec.startRecording();
            rec.readNext(); // Bad recording at beginning

            try {
                while (true) {
                    energy = 0;
                    float[] x = rec.readNext();

                    // Find if the signal is silence. If true --> pitch = 0
                    for (int j = 0; j < x.length; j++) energy += Math.pow(x[j], 2);
                    energy = 10 * Math.log10(energy);
                    Log.i("threshold", "energy = " + energy);
                    if (energy < -8) {
                        pitch = 0;
                        // Print no result on screen
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateTextView("-");
                            }
                        });
                    } else {
                        /**Yin detector according to the paper: "YIN, a fundamental
                         *frequency estimator for speech and music"*/
                        pitch = pitchDetector(x);
                        averagePitch(pitch);
                    }
                }
            } catch (Exception e) {
                rec.stopRecording();
            }
        }
    };


    private void averagePitch ( double pitch){
        final int N = 3; // Number of samples to average
        sum += pitch;
        final double mean = sum / count;

        if (pitch < (mean - 60) | pitch > (mean + 60)) { // Do not allow too different values
            sum -= pitch;
            if (diff) { // Maybe first value was wrong. Restart average.
                sum = 0;
                diff = false;
                count = 1;
            } else diff = true;
            return;
        } else {
            diff = false;
            count++;
        }

        if (count == N + 1) {
            // Print result on screen
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    updateTextView(Notes.difference(mean,freqReq));
                }
            });
            count = 1;
            sum = 0;
            diff = false;
        }
    }


    private double pitchDetector ( float[] x){
        // First step: Difference function
        differenceFunction(x);

        // Second step: Cumulative mean normalized difference function
        cumulativeMeanNormalizedDifference();

        // Third step: Absolute threshold
        int tau = absoluteThreshold();
        //Log.i("threshold","tau = "+tau);

        // Fourth step: Parabolic interpolation
        float interpolatedTau = parabolicInterpolation(tau);
        //Log.i("threshold","interpolated tau = "+interpolatedTau);

        return Audio.getSampleRate() / interpolatedTau;
    }


    private void differenceFunction ( float[] wave){
        for (int tau = 0; tau < length; tau++) {
            diffBuffer[tau] = 0; // Clean buffer
            for (int i = 0; i < length; i++) {
                diffBuffer[tau] += Math.pow((wave[i] - wave[i + tau]), 2);
            }
        }
    }


    private void cumulativeMeanNormalizedDifference () {
        float sum = 0;
        diffBuffer[0] = 1;
        for (int i = 1; i < diffBuffer.length; i++) {
            sum += diffBuffer[i];
            diffBuffer[i] *= i / sum;
        }
    }


    private int absoluteThreshold () {
        int tau;
        int minIndex = 2; // First two values are ones.
        float min = diffBuffer[minIndex];

        for (tau = 2; tau < length; tau++) {
            if (diffBuffer[tau] < min) {
                min = diffBuffer[tau];
                minIndex = tau;
            }
            if (diffBuffer[tau] < ABSOLUTE_THRESHOLD) {
                while (tau + 1 < length && diffBuffer[tau + 1] < diffBuffer[tau]) {
                    tau++;
                }
                break;
            }
        }

        // If there are not values deeper than threshold, the global minimum is chosen instead.
        tau = tau >= length ? minIndex : tau;
        return tau;
    }


    private float parabolicInterpolation ( int currentTau){
        int x0 = currentTau < 1 ? currentTau : currentTau - 1;
        int x2 = currentTau + 1 < length ? currentTau + 1 : currentTau;

        // Finds the better tau estimate
        float betterTau;

        if (x0 == currentTau) {
            if (diffBuffer[currentTau] <= diffBuffer[x2]) {
                betterTau = currentTau;
            } else {
                betterTau = x2;
            }
        } else if (x2 == currentTau) {
            if (diffBuffer[currentTau] <= diffBuffer[x0]) {
                betterTau = currentTau;
            } else {
                betterTau = x0;
            }
        } else {
            float s0 = diffBuffer[x0];
            float s1 = diffBuffer[currentTau];
            float s2 = diffBuffer[x2];

            betterTau = currentTau + (s2 - s0) / (2 * (2 * s1 - s2 - s0));
        }

        return betterTau;
    }
}
