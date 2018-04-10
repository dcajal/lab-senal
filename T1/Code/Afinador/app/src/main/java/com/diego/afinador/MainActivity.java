package com.diego.afinador;


import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.ByteBuffer;


public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Audio rec = new Audio();
        rec.startRecording();
        float[] transitory = rec.readNext(); // Bad recording at beginning
        float[] buf1 = rec.readNext();

        File file = new File(Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOCUMENTS), "prueba_audio.csv");

        try {
            FileOutputStream stream = new FileOutputStream(file);
            for (int i = 0; i < buf1.length; i++) {
                stream.write(Float.toString(buf1[i]).getBytes());
                stream.write(",".getBytes());
            }
            stream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        rec.stopRecording();
    }

}
