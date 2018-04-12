package com.diego.afinador;


import java.util.Locale;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;


public class MainActivity extends AppCompatActivity {

    // According to the YIN Paper, the threshold should be between 0.10 and 0.15
    private static final float ABSOLUTE_THRESHOLD = 0.125f;

    private float[] diffBuffer = new float[Audio.getReadSize() / 2];
    private final int length = diffBuffer.length;
    private int count = 1;
    private double sum = 0;
    private boolean diff = false;
    private TextView textView;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        textView = (TextView) findViewById(R.id.pitch_display);

        Thread t = new Thread(detectionThread);
        t.start();
    }


    public void updateTextView(double mean) {
        String display = String.format(Locale.ENGLISH, "%.2f Hz", mean);
        textView.setText(display);
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
                    if (energy < -6) {
                        pitch = 0;
                        // Print result on screen
                        runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                updateTextView(pitch);
                            }
                        });
                    } else {
                        /**Yin detector according to the paper: "YIN, a fundamental
                         *frequency estimator for speech and music"*/
                        pitch = pitchDetector(x);
                        averagePitch(pitch);
                    }
                }
            } catch (Exception e) { rec.stopRecording(); }
        }
    };


    private void averagePitch(double pitch) {
        final int N = 3; // Number of samples to average
        sum += pitch;
        final double mean = sum/count;

        if (pitch < (mean - 100) | pitch > (mean + 100)) { // Do not allow too different values
            sum -= pitch;
            if (diff) { // Maybe first value was wrong. Restart average.
                sum = 0;
                diff = false;
                count = 1;
            } else diff = true;
            return;
        } else {
            diff = false;
            count ++;
        }

        if (count == N+1) {
            // Print result on screen
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    updateTextView(mean);
                }
            });
            count = 1;
            sum = 0;
            diff = false;
        }
    }


    private double pitchDetector(float[] x) {
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

        return Audio.getSampleRate()/interpolatedTau;
    }


    private void differenceFunction(float[] wave) {
        for (int tau = 0; tau < length; tau++) {
            diffBuffer[tau] = 0; // Clean buffer
            for (int i = 0; i < length; i++) {
                diffBuffer[tau] += Math.pow((wave[i] - wave[i + tau]), 2);
            }
        }
    }


    private void cumulativeMeanNormalizedDifference() {
        float sum = 0;
        diffBuffer[0] = 1;
        for (int i = 1; i < diffBuffer.length; i++) {
            sum += diffBuffer[i];
            diffBuffer[i] *= i / sum;
        }
    }


    private int absoluteThreshold() {
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


    private float parabolicInterpolation(int currentTau) {
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




/*import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;
import android.os.Environment;*/


/*File file = new File(Environment.getExternalStoragePublicDirectory(
        Environment.DIRECTORY_DOCUMENTS), "audio.csv");

try {
    FileOutputStream stream = new FileOutputStream(file); // ,true for append
    for (int i = 0; i < x.length; i++) {
        stream.write(Float.toString(x[i]).getBytes());
        stream.write(",".getBytes());
    }
    stream.close();
} catch (Exception e) {
    e.printStackTrace();
}*/


/*File file1 = new File(Environment.getExternalStoragePublicDirectory(
        Environment.DIRECTORY_DOCUMENTS), "diff.csv");

try {
    FileOutputStream stream = new FileOutputStream(file1); // ,true for append
    for (int i = 0; i < length; i++) {
        stream.write(Float.toString(diffBuffer[i]).getBytes());
        stream.write(",".getBytes());
    }
    stream.close();
} catch (Exception e) {
    e.printStackTrace();
}*/


/*File file2 = new File(Environment.getExternalStoragePublicDirectory(
        Environment.DIRECTORY_DOCUMENTS), "cum.csv");

try {
    FileOutputStream stream = new FileOutputStream(file2); // ,true for append
    for (int i = 0; i < length; i++) {
        stream.write(Float.toString(diffBuffer[i]).getBytes());
        stream.write(",".getBytes());
    }
    stream.close();
} catch (Exception e) {
    e.printStackTrace();
}*/