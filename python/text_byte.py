import serial
s = serial.Serial('COM5', 115200);
s.write(open("image.bmp","rb").read());