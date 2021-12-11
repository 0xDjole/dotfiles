bluetoothctl power on && timeout 5 bluetoothctl scan on 
bluetoothctl connect F8:AB:E5:17:F0:7C && sleep 5 && pacmd set-default-sink bluez_sink.F8_AB_E5_17_F0_7C.a2dp_sink
