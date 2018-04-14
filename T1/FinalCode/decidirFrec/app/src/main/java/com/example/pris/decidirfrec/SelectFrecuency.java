package com.example.pris.decidirfrec;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;


public class SelectFrecuency extends AppCompatActivity implements  View.OnClickListener{

    private Button buttonDo, buttonDos,buttonRe, buttonRes, buttonMi, buttonFa, buttonFas,
    buttonSol, buttonSols, buttonLa, buttonLas, buttonSi;
    double frecReq, result, f_read;
    Notas nota = new Notas();
    DetectionThread detect = new DetectionThread();
    Thread t;
    boolean buttonPress = true;
    TextView textOut;
    static final double[] notes = {261.626,277.2,293.7,311.127,329.6,349.2,370,392,415.3,440,466.2,493.2};

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_frecuency);

        
        buttonPress = false;

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
        switch (view.getId()){
            case R.id.buttonDo:
                frecReq = notes[0];
                buttonPress = true;
                break;
            case R.id.buttonDos:
                frecReq = notes[1];
                buttonPress = true;
                break;
            case R.id.buttonRe:
                frecReq = notes[2];
                buttonPress = true;
                break;
            case R.id.buttonRes:
                frecReq = notes[3];
                buttonPress = true;
                break;
            case R.id.buttonMi:
                frecReq = notes[4];
                buttonPress = true;
                break;
            case R.id.buttonFa:
                frecReq = notes[5];
                buttonPress = true;
                break;
            case R.id.buttonFas:
                frecReq = notes[6];
                buttonPress = true;
                break;
            case R.id.buttonSol:
                frecReq = notes[7];
                buttonPress = true;
                break;
            case R.id.buttonSols:
                frecReq = notes[8];
                buttonPress = true;
                break;
            case R.id.buttonLa:
                frecReq = notes[9];
                buttonPress = true;
                break;
            case R.id.buttonLas:
                frecReq = notes[10];
                buttonPress = true;
                break;
            case R.id.buttonSi:
                frecReq = notes[11];
                buttonPress = true;
                break;
        }
        t= new Thread(detect);
        t.start();
        
        f_read = detect.getPitch();

        if(buttonPress) {
            result = nota.difference(f_read, frecReq);
        }
        textOut = findViewById(R.id.editTextOut);
        textOut.setText(String.format("%.2f", result));
    }


}



