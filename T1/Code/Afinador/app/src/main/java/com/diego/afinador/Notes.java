package com.diego.afinador;

public class Notes {
    private static final double lowerB = 246.942;
    private static final double upperC = 523.251;
    private static int dispNote;
    static final String[] notesName = {"DO", "DO#", "RE", "RE#", "MI", "FA", "FA#", "SOL", "SOL#", "LA", "LA#", "SI"};
    static final double[] notesFreq = {261.626, 277.2, 293.7, 311.127, 329.6, 349.2, 370, 392, 415.3, 440, 466.2, 493.2};


    public static double difference(double freq, double freqReq) {
        int octave = 1;
        boolean wasLow = false;
        double freqAux = freq;

        if (freq < lowerB) {
            while (freqAux < lowerB) {
                octave++;
                freqAux = freq * (double)octave;
                wasLow = true;
            }
        } else if (freq > upperC) {
            while (freqAux > upperC) {
                octave++;
                freqAux = freq / (double)octave;
                wasLow = false;
            }
        }

        if (wasLow) {
            // Real diff is lower in a lower octave
            return (freqAux - freqReq) / (double)octave;
        } else {
            // Real diff is higher in a higher octave
            return (freqAux - freqReq) * (double)octave;
        }
    }


    public static double difference(double freq) {
        int i;
        int octave = 1;
        int currentNote = 0;
        boolean wasLow = true;
        double freqAux = freq;
        double diffCurrent, diffUpper;

        if (freq < lowerB) {
            while (freqAux < lowerB) {
                octave++;
                freqAux = freq * (double)octave;
                wasLow = true;
            }
        } else if (freq > upperC) {
            while (freqAux > upperC) {
                octave++;
                freqAux = freq / (double)octave;
                wasLow = false;
            }
        }

        // Here we have the note transposed to the 4th octave in freqAux and the number of octaves up/down

        if (freqAux < notesFreq[0]) {
            // Note is between lower B and C
            currentNote = -1;
        } else {
            for (i = 1; i < notesFreq.length; i++) {
                if (freqAux > notesFreq[i]) {
                    currentNote = i;
                }
            }
        }

        // The real note is between the current note and the upper

        if (currentNote == 11) {
            // Note is between B and upper C
            diffCurrent = freqAux - notesFreq[11];
            diffUpper = freqAux - upperC;
        } else if (currentNote == -1) {
            diffCurrent = freqAux - lowerB;
            diffUpper = freqAux - notesFreq[0];
        } else {
            diffCurrent = freqAux - notesFreq[currentNote];
            diffUpper = freqAux - notesFreq[currentNote + 1];
        }


        if (Math.abs(diffCurrent) > Math.abs(diffUpper)) {
            // The note is the upper one of the pair
            if (currentNote == -1) { //The note is a C
                dispNote = 0;
            } else {
                dispNote = currentNote + 1;
            }

            if (wasLow) {
                return diffUpper/(double)octave; // The real difference is minor in a lower octave
            } else {
                return diffUpper*(double)octave;
            }

        } else {
            // The note is the lower one of the pair
            if (currentNote == -1) { //The note is a B
                dispNote = 11;
            } else {
                dispNote = currentNote;
            }

            if (wasLow) {
                return diffCurrent/(double)octave;
            } else {
                return diffCurrent*(double)octave;
            }
        }

    }

    public static int getDispNote() { return dispNote; }
}