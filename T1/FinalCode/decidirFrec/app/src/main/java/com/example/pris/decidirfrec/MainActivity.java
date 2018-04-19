package com.example.pris.decidirfrec;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {
    Button buttonFreq, buttonNoSelect;
    Intent intentSelectF, intentNoSelectF;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        buttonFreq =  findViewById(R.id.buttonSeleccionFrecuencia);
        buttonNoSelect =  findViewById(R.id.buttonNoSeleccionFrecuencia);

        buttonFreq.setOnClickListener(this);
        buttonNoSelect.setOnClickListener(this);

        intentNoSelectF = new Intent(getApplicationContext() , NoSelectFrecuency.class);
        intentSelectF = new Intent(getApplicationContext(), SelectFrecuency.class);

    }

    @Override
    public void onClick(View view) {
        switch (view.getId()){
            case R.id.buttonNoSeleccionFrecuencia:
                MainActivity.this.startActivity(intentNoSelectF);
                break;
            case R.id.buttonSeleccionFrecuencia:
                MainActivity.this.startActivity(intentSelectF);
                break;
        }
    }
}
