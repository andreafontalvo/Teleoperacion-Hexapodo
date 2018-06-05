close all
clear all
clc
%try
Nunchuck =  serial ('/dev/tty.usbmodem1411','BaudRate',9600,'TimeOut',0.1);
Transmisor =  serial ('/dev/tty.usbserial-AJ03EEGI','BaudRate',9600,'TimeOut',0.1);
fopen(Nunchuck);fopen(Transmisor);


llave = true;
while llave
    fwrite(Nunchuck,'D','uchar');
    %pause(0.5);
    lectura = fscanf(Nunchuck)
    fwrite(Transmisor,lectura,'uchar');
end
%catch
fclose(instrfind);
%end