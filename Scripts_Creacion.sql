--Luego de decidirse por un motor de base de datos relacional, lleg� el momento de generar la
--base de datos. En esta oportunidad utilizar�n SQL Server.
--Deber� instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
--las configuraciones aplicadas (ubicaci�n de archivos, memoria asignada, seguridad, puertos,
--etc.) en un documento como el que le entregar�a al DBA.
--Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deber� entregar
--un archivo .sql con el script completo de creaci�n (debe funcionar si se lo ejecuta �tal cual� es
--entregado en una sola ejecuci�n). Incluya comentarios para indicar qu� hace cada m�dulo
--de c�digo.
--Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde,
--tambi�n debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla.
--Los nombres de los store procedures NO deben comenzar con �SP�.
--Algunas operaciones implicar�n store procedures que involucran varias tablas, uso de
--transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
--Aseg�rense de que los comentarios que acompa�en al c�digo lo expliquen.
--Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto
--en la creaci�n de objetos. NO use el esquema �dbo�.
--Todos los SP creados deben estar acompa�ados de juegos de prueba. Se espera que
--realicen validaciones b�sicas en los SP (p/e cantidad mayor a cero, CUIT v�lido, etc.) y que
--en los juegos de prueba demuestren la correcta aplicaci�n de las validaciones.
--Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
--cada caso el resultado esperado
--El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
--de entrega, n�mero de grupo, nombre de la materia, nombres y DNI de los alumnos.
--Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
--la secci�n de pr�cticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

--Alumnos:
--Arias, Kevin - 41.246.810 
--Nasi, Valentin - 44.851.378
--Rodriguez, Florencia Lorena - 41.558.145
--Traversa, Franco - 44.510.896

--Fecha de Entrega: 19 de Mayo de 2025
--Grupo N7
--Materia: Base de Datos Aplicada

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'SOLNORTE_SOCIOS')
BEGIN
    DROP DATABASE SOLNORTE_SOCIOS;
END
GO

-- Creamos la base
CREATE DATABASE SOLNORTE_SOCIOS;
GO

-- Usamos la base
USE SOLNORTE_SOCIOS;
GO

-- Tabla TipoSocio: Define las categor�as de socios (ej. adulto, menor, etc.).
CREATE TABLE TipoSocio (
    Tipo_ID INT PRIMARY KEY, -- ID �nico para cada tipo de socio.
    NombreDeCategoria VARCHAR(50) NOT NULL, -- Nombre de la categor�a del socio.
    EdadDesde INT NOT NULL, -- Edad m�nima para esta categor�a.
    EdadHasta INT NOT NULL, -- Edad m�xima para esta categor�a.
    Precio DECIMAL(10, 2) NOT NULL -- Precio asociado a esta categor�a de socio.
);

-- Tabla Socio: Almacena la informaci�n principal de cada miembro del club.
CREATE TABLE Socio (
    Socio_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- ID �nico para cada socio, se autoincrementa.
    DNI NUMERIC(8,0) UNIQUE NOT NULL, -- N�mero de DNI del socio, �nico e identificador principal.
    Tipo_ID INT NOT NULL, -- Clave for�nea que referencia el tipo de socio.
    nombreapellido VARCHAR(100) NOT NULL, -- Nombre y apellido del socio.
    email VARCHAR(100) NULL, -- Correo electr�nico del socio, opcional.
    fechanacimiento DATE NOT NULL, -- Fecha de nacimiento del socio.
    contacto VARCHAR(20), -- N�mero de contacto del socio.
    contacto_emergencia VARCHAR(20), -- N�mero de contacto para emergencias.
    Activo BIT DEFAULT 1, -- Indica si el socio est� activo (por defecto, s�).
    FOREIGN KEY (Tipo_ID) REFERENCES TipoSocio(Tipo_ID) -- Establece la relaci�n con la tabla TipoSocio.
);

-- Tabla ResponsableDe: Registra las relaciones de responsabilidad entre socios (ej. adulto y menor).
CREATE TABLE responsablede (
    AdultoID INT, -- ID del socio adulto responsable.
    MenorID INT, -- ID del socio menor a cargo.
    parentesco VARCHAR(50), -- Describe el parentesco (ej. padre, madre).
    FOREIGN KEY(AdultoID) REFERENCES Socio(Socio_ID), -- Relaci�n con el socio adulto.
    FOREIGN KEY(MenorID) REFERENCES Socio(Socio_ID) -- Relaci�n con el socio menor.
);

-- Tabla Prestador_de_Salud: Almacena informaci�n sobre los prestadores de salud de los socios.
CREATE TABLE Prestador_de_Salud (
    Socio_ID INT NOT NULL, -- ID del socio asociado al prestador de salud.
    ID INT PRIMARY KEY NOT NULL, -- ID �nico del prestador de salud.
    tipo VARCHAR(50), -- Tipo de prestador (ej. obra social, prepaga).
    nombre VARCHAR(50), -- Nombre del prestador de salud.
    numero INT, -- N�mero de identificaci�n del prestador.
    contacto INT, -- N�mero de contacto del prestador.
    FOREIGN KEY(Socio_ID) REFERENCES Socio(Socio_ID) -- Relaci�n con la tabla Socio.
);

-- Tabla Deporte: Define los deportes disponibles en el club.
CREATE TABLE Deporte (
    Deporte_ID INT NOT NULL PRIMARY KEY, -- ID �nico para cada deporte.
    nombre VARCHAR(50), -- Nombre del deporte.
    precio DECIMAL(10,2) NOT NULL -- Precio de la actividad deportiva.
);

-- Tabla Inscripto: Registra en qu� deportes est� inscrito cada socio.
CREATE TABLE Inscripto (
    Deporte_ID INT PRIMARY KEY NOT NULL, -- ID del deporte.
    Socio_ID INT, -- ID del socio.
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID), -- Relaci�n con la tabla Socio.
    FOREIGN KEY (Deporte_ID) REFERENCES Deporte(Deporte_ID) -- Relaci�n con la tabla Deporte.
);



-- Tabla Clase: Define las clases espec�ficas de cada deporte.
CREATE TABLE Clase (
    ID_Clase INT NOT NULL PRIMARY KEY, -- ID �nico para cada clase.
    Deporte_ID INT, -- ID del deporte al que pertenece la clase.
    Socio_ID INT, -- ID del socio que toma la clase.
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID), -- Relaci�n con la tabla Socio.
    FOREIGN KEY (Deporte_ID) REFERENCES Inscripto(Deporte_ID) -- Relaci�n con la tabla Inscripto.
);

-- Tabla Turnos: Gestiona los horarios de las clases.
CREATE TABLE Turnos (
    ID_Clase INT NOT NULL, -- ID de la clase.
    dia DATE NOT NULL, -- Fecha del turno.
    hora TIME NOT NULL, -- Hora del turno (corregido a TIME para horas).
    FOREIGN KEY (ID_Clase) REFERENCES Clase(ID_Clase) -- Relaci�n con la tabla Clase.
);

-- Tabla Actividad: Almacena informaci�n sobre los costos de las actividades deportivas.
CREATE TABLE Actividad (
    Deporte_ID INT PRIMARY KEY NOT NULL, -- ID del deporte asociado a la actividad.
    SubTotal DECIMAL(10,2) NOT NULL, -- Subtotal del costo de la actividad.
    Descuento INT, -- Porcentaje de descuento aplicado.
    FOREIGN KEY (Deporte_ID) REFERENCES Inscripto(Deporte_ID) -- Relaci�n con la tabla Inscripto.
);

-- Tabla Membresia: Gestiona los detalles de las membres�as de los socios.
CREATE TABLE Membresia (
    Socio_ID INT NOT NULL PRIMARY KEY, -- ID del socio de la membres�a.
    Menor_ID INT, -- ID del menor asociado a la membres�a (si aplica).
    Subtotal DECIMAL(10,2) NOT NULL, -- Subtotal de la membres�a.
    descuento INT, -- Porcentaje de descuento aplicado.
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID), -- Relaci�n con la tabla Socio.
    FOREIGN KEY (Menor_ID) REFERENCES Socio(Socio_ID) -- Relaci�n con el socio menor.
);

-- Tabla FacturaArca: Almacena los datos de las facturas emitidas.
CREATE TABLE FacturaArca (
    Factura_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, -- ID �nico de la factura, se autoincrementa.
    Socio_ID INT NOT NULL, -- ID del socio al que pertenece la factura.
    Tipo VARCHAR(50) NOT NULL, -- Tipo de factura (ej. membres�a, deporte).
    Total DECIMAL(10,2) NOT NULL, -- Monto total de la factura.
    Estado VARCHAR(50), -- Estado de la factura (ej. pagada, pendiente).
    Vencimiento1 DATE NOT NULL, -- Primera fecha de vencimiento.
    Vencimiento2 DATE NOT NULL, -- Segunda fecha de vencimiento.
    Recargo DECIMAL(10,2) NULL, -- Monto de recargo por mora, opcional.
    NumeroFactura INT UNIQUE NOT NULL, -- N�mero de factura �nico (clave primaria �nica).
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID) -- Relaci�n con la tabla Socio.
);

-- Tabla MedioDePago: Define los diferentes medios de pago aceptados.
CREATE TABLE MedioDePago (
    MedioPago_ID INT PRIMARY KEY NOT NULL, -- ID �nico del medio de pago.
    nombre VARCHAR(50), -- Nombre del medio de pago (ej. tarjeta de cr�dito, efectivo).
    descripcion VARCHAR(50), -- Descripci�n del medio de pago.
    habilitado BIT DEFAULT 1 -- Indica si el medio de pago est� habilitado.
);

-- Tabla Pago: Registra los pagos realizados por los socios.
CREATE TABLE Pago (
    Pago_ID INT PRIMARY KEY NOT NULL, -- ID �nico del pago.
    Factura_ID INT, -- ID de la factura a la que corresponde el pago.
    MedioPago_ID INT, -- ID del medio de pago utilizado.
    fecha DATE, -- Fecha en que se realiz� el pago.
    importe DECIMAL(10,2) NOT NULL, -- Importe pagado.
    Reembolso INT, -- Monto de reembolso (si aplica).
    FOREIGN KEY (Factura_ID) REFERENCES FacturaArca(Factura_ID), -- Relaci�n con la tabla FacturaArca.
    FOREIGN KEY (MedioPago_ID) REFERENCES MedioDePago(MedioPago_ID) -- Relaci�n con la tabla MedioDePago.
);

-- Tabla Pileta: Gestiona las entradas a la pileta.
CREATE TABLE Pileta (
    Entrada_ID INT PRIMARY KEY, -- ID �nico de la entrada a la pileta.
    Fecha DATE, -- Fecha de la entrada.
    Tipo VARCHAR(50), -- Tipo de entrada (ej. diario, pase).
    Precio DECIMAL(10,2), -- Precio de la entrada.
    Lluvia BIT, -- Indica si hubo lluvia (afecta el uso de la pileta).
    Reintegro BIT -- Indica si se realiz� un reintegro.
);

-- Tabla Invitado: Registra la informaci�n de los invitados de los socios.
CREATE TABLE Invitado (
    Invitado_ID INT PRIMARY KEY, -- ID �nico del invitado.
    Socio_ID INT, -- ID del socio que invita.
    Nombre VARCHAR(100), -- Nombre del invitado.
    Apellido VARCHAR(100), -- Apellido del invitado.
    Documento VARCHAR(20), -- N�mero de documento del invitado.
    Fecha DATE, -- Fecha de la visita.
    Entrada_ID INT, -- ID de la entrada utilizada (ej. para pileta).
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID), -- Relaci�n con la tabla Socio.
    FOREIGN KEY (Entrada_ID) REFERENCES Pileta(Entrada_ID) -- Relaci�n con la tabla Pileta.
);



-- Tabla Colonia: Almacena informaci�n espec�fica sobre la colonia de verano.
CREATE TABLE Colonia (
    Entrada_ID INT PRIMARY KEY, -- ID de la entrada asociada a la colonia.
    Precio DECIMAL(10,2), -- Precio de la colonia.
    FOREIGN KEY (Entrada_ID) REFERENCES Pileta(Entrada_ID) -- Relaci�n con la tabla Pileta (una entrada puede ser de colonia).
);

-- Tabla SUM: Almacena informaci�n sobre el alquiler del Sal�n de Usos M�ltiples (SUM).
CREATE TABLE GYM (
    Entrada_ID INT PRIMARY KEY, -- ID de la entrada asociada al SUM.
    Precio DECIMAL(10,2), -- Precio del alquiler del SUM.
    Fecha_Reserva DATE, -- Fecha de la reserva del SUM.
    Estado VARCHAR(50), -- Estado de la reserva (ej. confirmado, pendiente).
    FOREIGN KEY (Entrada_ID) REFERENCES Pileta(Entrada_ID) -- Relaci�n con la tabla Pileta (una entrada puede ser para el SUM).
);

-- Tabla ActividadExtra: Registra actividades extra-deportivas de los socios.
CREATE TABLE ActividadExtra (
    ID_ActividadExtra INT PRIMARY KEY, -- ID �nico de la actividad extra.
    Socio_ID INT, -- ID del socio que participa en la actividad extra.
    Nombre VARCHAR(100), -- Nombre de la actividad extra.
    FOREIGN KEY (Socio_ID) REFERENCES Socio(Socio_ID) -- Relaci�n con la tabla Socio.
);