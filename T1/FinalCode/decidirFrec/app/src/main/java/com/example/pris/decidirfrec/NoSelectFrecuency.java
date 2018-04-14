package com.example.pris.decidirfrec;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;


public class NoSelectFrecuency extends AppCompatActivity implements  View.OnClickListener{
    Notas nota = new Notas();
    double minF, min2F, frec;
    int posMin, pos2Min;
    static final double[] notesF = {261.626,277.2,293.7,311.127,329.6,349.2,370,392,415.3,440,466.2,493.2};
    static final String[] notes = {"DO", "DO#","RE","RE#","MI","FA","FA#","SOL","SOL#","LA","LA#","SI"};
    Button buttonStart, buttonStop;
    Boolean start = false;
    TextView textNoteInf, textNoteSup, textFreqInf, textFreqSup;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_no_select_frecuency);

        buttonStart = (Button) findViewById(R.id.buttonStart);
        buttonStop = (Button) findViewById(R.id.buttonStop);
        buttonStart.setOnClickListener(this);
        buttonStop.setOnClickListener(this);

        minF = nota.getMinF();
        min2F = nota.getMin2F();
        posMin = nota.getPosMin();
        pos2Min = nota.getposMin2();


    }

    @Override
    public void onClick(View view) {
        Random rand =new Random();
        switch (view.getId()){
            case R.id.buttonStart:
                start = true;
                break;
            case R.id.buttonStop:
                start = false;
        }
        if (start) {
            frec = 89 + rand.nextInt(536);
            //frec = 555;
            Toast.makeText(NoSelectFrecuency.this, "F= " + String.valueOf(frec), Toast.LENGTH_SHORT).show();
            nota.noSelect(frec);
            minF = nota.getMinF();
            min2F = nota.getMin2F();
            posMin = nota.getPosMin();
            pos2Min = nota.getposMin2();

        /*
        * Si la diferencia es positiva la frec que el usuario toca sera inferior por lo que nota que
        * mostraremos será la superior
        * */
        /*
        * textOut = (TextView)findViewById(R.id.editTextOut);
        textOut.setText(String.format("%.2f", result));
        * */
            textFreqSup = (TextView) findViewById(R.id.editTextSup);
            textFreqInf = (TextView) findViewById(R.id.editTextInf);
            textNoteInf = (TextView) findViewById(R.id.editTextNoteI);
            textNoteSup = (TextView) findViewById(R.id.editTextNoteS);

            if(minF>=0){
                textFreqSup.setText(String.format("%.2f",minF));
                textFreqInf.setText(String.format("%.2f",min2F));
                textNoteSup.setText(notes[posMin]);
                textNoteInf.setText(notes[pos2Min]);
            }else{
                textFreqSup.setText(String.format("%.2f",min2F));
                textFreqInf.setText(String.format("%.2f",minF));
                textNoteSup.setText(notes[pos2Min]);
                textNoteInf.setText(notes[posMin]);
            }
        }
    }
}

