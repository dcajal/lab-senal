package com.example.pris.decidirfrec;

/**
 * Created by Pris on 11/04/2018.
 */

public class Notas {
    double freq,note, frecReq;

    static final double[] notes = {261.626,277.2,293.7,311.127,329.6,349.2,370,392,415.3,440,466.2,493.2};
    private double minF, min2F;
    private int posMin, posMin2;

    public double difference(double frecuency, double frecReq){
        /*
        * El usuario selecciona la cuerda que quiere afinar (frecReq) y el valor
        * que se devuelve es la diferencia entre ambas frecuencias
        * */

        this.freq = frecuency;
        this.frecReq = frecReq;

        note = freq -frecReq;

        return note;
    }

    public void noSelect (double frecuency){
        this.freq = frecuency;
        double[] diff = new double[notes.length];
        int i;

        if(freq <=notes[0] || freq >= notes[notes.length-1]){
            if(freq <=notes[0]){
                minF= notes[0]- freq;
                posMin = 0;
                min2F = 0;
                posMin2 = 0;
            }else{
                minF= notes[notes.length-1]- freq;
                posMin = notes.length-1;
                min2F = 0;
                posMin2 = 0;
            }
        }else{
            for (i =0; i<notes.length; i++){
            diff[i]= notes[i]- freq;
            if(i==0){
                minF = diff[i];
                posMin = i;
            }else{
                if(Math.abs(diff[i])<Math.abs(minF)){
                    posMin2 = posMin;
                    min2F=minF;
                    minF = diff[i];
                    posMin = i;
                }
            }
        }
        }
    }
    public double getMinF(){
        return minF;
    }
    public double getMin2F(){
        return min2F;
    }
    public int getPosMin(){
        return posMin;
    }
    public int getposMin2(){
        return posMin2;
    }


}
