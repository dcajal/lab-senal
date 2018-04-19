package com.diego.afinador;


import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

public class MainActivity extends Activity {
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Intent intentSelectF = new Intent(getApplicationContext(), SelectFrequency.class);
        MainActivity.this.startActivity(intentSelectF);
    }
}


//public class MainActivity extends AppCompatActivity implements View.OnClickListener {
//    Button buttonFreq, buttonNoSelect;
//    Intent intentSelectF, intentNoSelectF;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
//
//        buttonFreq =  findViewById(R.id.buttonSeleccionFrecuencia);
//        buttonNoSelect =  findViewById(R.id.buttonNoSeleccionFrecuencia);
//
//        buttonFreq.setOnClickListener(this);
//        buttonNoSelect.setOnClickListener(this);
//
//        //intentNoSelectF = new Intent(getApplicationContext() , NoSelectFrequency.class);
//        intentSelectF = new Intent(getApplicationContext(), SelectFrequency.class);
//
//    }
//
//    @Override
//    public void onClick(View view) {
//        switch (view.getId()){
//            case R.id.buttonNoSeleccionFrecuencia:
//                //MainActivity.this.startActivity(intentNoSelectF);
//                break;
//            case R.id.buttonSeleccionFrecuencia:
//                MainActivity.this.startActivity(intentSelectF);
//                break;
//        }
//    }
//}




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