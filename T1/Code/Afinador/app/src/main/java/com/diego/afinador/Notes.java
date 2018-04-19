package com.diego.afinador;

public class Notes {
    static final String[] notesName = {"DO", "DO#", "RE", "RE#", "MI", "FA", "FA#", "SOL", "SOL#", "LA", "LA#", "SI"};
    static final double[] notesFreq = {261.626, 277.2, 293.7, 311.127, 329.6, 349.2, 370, 392, 415.3, 440, 466.2, 493.2};
    private static final double lowerB = 246.942;
    private static final double upperC = 523.251;

    public static double difference(double freq, double freqReq) {
        int octave = 1;
        double freqAux = freq;

        if (freq < lowerB) {
            while (freqAux < lowerB) {
                octave++;
                freqAux = freq * octave;
            }
            freqReq = freqReq / octave;
        } else if (freq > upperC) {
            while (freqAux > upperC) {
                octave++;
                freqAux = freq / octave;
            }
            freqReq = freqReq * octave;
        }

        return (freq - freqReq);
    }




    /*
    int currentNote;

    public static double difference(double freq) {
        int i;
        int octave = 1;
        boolean wasLow;
        double freqAux = freq;
        double[] diff = new double[notesFreq.length];

        if (freq < notesFreq[0] - 20) {
            while (freqAux < notesFreq[0] - 20) {
                octave++;
                freqAux = freq * octave;
                wasLow = true;
            }
        } else if (freq > notesFreq[11] + 30) {
            while (freqAux > notesFreq[11] + 30) {
                octave++;
                freqAux = freq / octave;
                wasLow = false;
            }
        }

        // Here we have the note transposed to the 4th octave in freqAux and the number of octaves up/down

        for (i = 0; i < note.length; i++) {
            diff[i] = note[i] - freq;
            if (i == 0) {
                minF = diff[i];
                posMin = i;
            } else {
                if (Math.abs(diff[i]) < Math.abs(minF)) {
                    posMin2 = posMin;
                    min2F = minF;
                    minF = diff[i];
                    posMin = i;
                }
            }
        }
    }*/
}