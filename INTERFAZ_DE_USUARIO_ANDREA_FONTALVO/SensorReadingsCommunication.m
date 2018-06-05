function [numpackages,MovementReading,LeftReading,RightReading,FrontReading,CompassReading]=SensorReadingsCommunication()

% Este código permite tomar las lecturas de los sensores almacenadas cuando
% el canal no se encuentra disponible
% Proyecto Final Andrea Fontalvo

% Septiembre 3 - 2017

% Arduino = serial('/dev/tty.usbmodem1431'); %SERIAL MAC 
Arduino = serial('COM5');
fclose(instrfind);
set(Arduino,'Baudrate',115200); % se configura la velocidad a 9600 Baudios
set(Arduino,'StopBits',1); % se configura bit de parada a uno
set(Arduino,'DataBits',8); % se configura que el dato es de 8 bits, debe estar entre 5 y 8
set(Arduino,'Parity','none'); % se configura sin paridad
set(Arduino,'Terminator','CR/LF');% ?c? caracter con que finaliza el env?o
set(Arduino,'OutputBufferSize',2); % ?n? es el n?mero de bytes a enviar
set(Arduino,'InputBufferSize' ,50); % ?n? es el n?mero de bytes a recibir
set(Arduino,'Timeout',5); % 5 seg1undos de tiempo de espera
fopen(Arduino);
pause(10)

try
            InitialCommand = 'R'; %Iniciar Comunicacion
            fwrite(Arduino,InitialCommand,'uchar');
            pause(0.1)
            llave_emergencia = true;
            while llave_emergencia
                codified_packagenumber = fscanf(Arduino);
                if isempty(codified_packagenumber) == 0
                    llave_emergencia =  false;
                end
            end
            vector_packagenumber = strsplit(codified_packagenumber,'P');
            numpackages = (str2double(vector_packagenumber(2)))*1000; %Numero de paquetes a recibir
            pause(0.1);
            PackageConfirmation = 'Y'; %Pedir paquetes almacenados
            fwrite(Arduino,PackageConfirmation,'uchar');
            for i=1:numpackages
                SensorReadingsPackage = fscanf(Arduino);
                SensorReadingsChar = char(SensorReadingsPackage);
                LengthSensorReadings = length(SensorReadingsChar);
                SensorReadingSplit = strsplit(SensorReadingsChar,{'M','F','L','R','C'});
                MovementReading(i,1) = str2double(SensorReadingSplit(2))*1000 %lecturas de los movimientos ejecutados
                FrontReading(i,1) = str2double(SensorReadingSplit(3))*1000 %lecturas del ultrasonido Front
                LeftReading(i,1) = str2double(SensorReadingSplit(4))*1000 %lecturas del ultrasonido Left
                RightReading(i,1) = str2double(SensorReadingSplit(5))*1000%lecturas del ultrasonido Right
                CompassReading(i,1) = str2double(SensorReadingSplit(6))*1000 %lecturas de la brujula digital
            end
            BlankReadingRecords = 'K'; %Pedir paquetes almacenados
            fwrite(Arduino,BlankReadingRecords,'uchar');
catch
    fclose(Arduino);
end
end
