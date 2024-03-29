USE [master]
GO
/****** Object:  Database [TEST_SEGUROS]    Script Date: 16/9/2019 9:12:41 p. m. ******/
CREATE DATABASE [TEST_SEGUROS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TEST_SEGUROS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\TEST_SEGUROS.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'TEST_SEGUROS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\TEST_SEGUROS_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [TEST_SEGUROS] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TEST_SEGUROS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TEST_SEGUROS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET ARITHABORT OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [TEST_SEGUROS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TEST_SEGUROS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TEST_SEGUROS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TEST_SEGUROS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TEST_SEGUROS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET RECOVERY FULL 
GO
ALTER DATABASE [TEST_SEGUROS] SET  MULTI_USER 
GO
ALTER DATABASE [TEST_SEGUROS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TEST_SEGUROS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TEST_SEGUROS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TEST_SEGUROS] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [TEST_SEGUROS]
GO
/****** Object:  StoredProcedure [dbo].[Actualizar_Poliza_Seguros]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Actualizar_Poliza_Seguros]
(
	@piCodigoPoliza				INT,
	@psNombre					VARCHAR(50),
    @psDescripcion				VARCHAR(500),
    @piTipoCubrimiento			INT,
    @piPeriodoCoberturaMeses	INT,
    @pfPrecioPoliza				FLOAT,
    @piTipoRiesgo				INT
)
AS
/******************************************************************
<Nombre>Actualizar_Poliza_Seguros</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>UPDATE en la tabla de polizas</Descripción>
<Entradas>	
	@piCodigoPoliza				INT,
	@psNombre					VARCHAR(50),
    @psDescripcion				VARCHAR(500),
    @piTipoCubrimiento			INT,
    @piPeriodoCoberturaMeses	INT,
    @pfPrecioPoliza				FLOAT,
    @piTipoRiesgo				INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
BEGIN TRANSACTION TRA_Actualizar_Poliza

BEGIN TRY   		

UPDATE [dbo].[POLIZA_SEGUROS]
SET		[Nombre]				=@psNombre,
        [Descripcion]			=@psDescripcion,
        [TipoCubrimiento]		=@piTipoCubrimiento,
        [PeriodoCoberturaMeses]	=@piPeriodoCoberturaMeses,
        [PrecioPoliza]			=@pfPrecioPoliza,
        [TipoRiesgo]			=@piTipoRiesgo
WHERE CodigoSeguro = @piCodigoPoliza
  
	--si no hubo error se termina la transacción
	COMMIT TRANSACTION TRA_Actualizar_Poliza
END TRY 
BEGIN CATCH
	
	DECLARE @vsMensajeErrorActual VARCHAR(5000) = ERROR_MESSAGE();
	ROLLBACK TRANSACTION TRA_Actualizar_Poliza;
    RAISERROR(@vsMensajeErrorActual, 16,0);
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Asignar_Poliza_Cliente]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Asignar_Poliza_Cliente]
(
	@piCodigoPoliza		INT,
	@piCodigoCliente	INT,
	@pdFechaInicioVigencia DATE
)
AS
/******************************************************************
<Nombre>Asignar_Poliza_Cliente</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>Asigna una póliza a un cliente</Descripción>
<Entradas>	
	@piCodigoPoliza		INT,
	@piCodigoCliente	INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
INSERT INTO [dbo].[POLIZA_POR_CLIENTE]
           ([Codigo_Cliente]
           ,[Codigo_Poliza]
           ,[InicioVigencia])
     VALUES
           (@piCodigoCliente, @piCodigoPoliza,@pdFechaInicioVigencia)
  

GO
/****** Object:  StoredProcedure [dbo].[Consultar_Poliza_Seguros]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Consultar_Poliza_Seguros]
(
	@piCodigoPoliza				INT	
)
AS
/******************************************************************
<Nombre>Consultar_Poliza_Seguros</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>SELECT en la tabla de pólizas, retorna un valor específico o todos los items de la tabla</Descripción>
<Entradas>	
	@piCodigoPoliza				INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
SELECT [CodigoSeguro]
      ,[Nombre]
      ,[Descripcion]
      ,[TipoCubrimiento]
      ,[PeriodoCoberturaMeses]
      ,[PrecioPoliza]
      ,[TipoRiesgo]
  FROM [dbo].[POLIZA_SEGUROS]
  WHERE @piCodigoPoliza IS NULL OR CodigoSeguro = @piCodigoPoliza
  

GO
/****** Object:  StoredProcedure [dbo].[Eliminar_Poliza_Cliente]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Eliminar_Poliza_Cliente]
(
	@piCodigoPoliza		INT,
	@piCodigoCliente	INT	
)
AS
/******************************************************************
<Nombre>Asignar_Poliza_Cliente</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>Asigna una póliza a un cliente</Descripción>
<Entradas>	
	@piCodigoPoliza		INT,
	@piCodigoCliente	INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
DELETE [dbo].[POLIZA_POR_CLIENTE]
WHERE	Codigo_Cliente = @piCodigoCliente AND
		Codigo_Poliza=@piCodigoPoliza
  

GO
/****** Object:  StoredProcedure [dbo].[Eliminar_Poliza_Seguros]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Eliminar_Poliza_Seguros]
(
	@piCodigoPoliza				INT	
)
AS
/******************************************************************
<Nombre>Eliminar_Poliza_Seguros</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>DELETE en la tabla de pólizas</Descripción>
<Entradas>	
	@piCodigoPoliza				INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
BEGIN TRANSACTION TRA_Eliminar_Poliza

BEGIN TRY   		

	DECLARE @vsMensajeError VARCHAR(5000)

	--Se valida si la póliza esta asociada a un cliente
	IF(EXISTS(SELECT 1 
			  FROM	dbo.POLIZA_POR_CLIENTE
			  WHERE (Codigo_Poliza = @piCodigoPoliza)))
	BEGIN
		SET @vsMensajeError = 'La póliza se encuentra asociada a un cliente' 
		
		RAISERROR(@vsMensajeError, 16,0);
	END

	DELETE [dbo].[POLIZA_SEGUROS]
	WHERE CodigoSeguro = @piCodigoPoliza
  
	--si no hubo error se termina la transacción
	COMMIT TRANSACTION TRA_Eliminar_Poliza
END TRY 
BEGIN CATCH
	
	DECLARE @vsMensajeErrorActual VARCHAR(5000) = ERROR_MESSAGE();
	ROLLBACK TRANSACTION TRA_Eliminar_Poliza;
    RAISERROR(@vsMensajeErrorActual, 16,0);
END CATCH

GO
/****** Object:  StoredProcedure [dbo].[Insertar_Poliza_Seguros]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Insertar_Poliza_Seguros]
(
	@psNombre					VARCHAR(50),
    @psDescripcion				VARCHAR(500),
    @piTipoCubrimiento			INT,
    @piPeriodoCoberturaMeses	INT,
    @pfPrecioPoliza				FLOAT,
    @piTipoRiesgo				INT
)
AS
/******************************************************************
<Nombre>Insertar_Poliza_Seguros</Nombre>
<Sistema>TEST POLIZAS</Sistema>
<Descripción>INSERT en la tabla de polizas</Descripción>
<Entradas>	
	@psNombre					VARCHAR(50),
    @psDescripcion				VARCHAR(500),
    @piTipoCubrimiento			INT,   
    @piPeriodoCoberturaMeses	INT,
    @pfPrecioPoliza				FLOAT,
    @piTipoRiesgo				INT
</Entradas>
<Autor>Tatiana Villegas Hernández</Autor>
<Fecha>16 de setiembre del 2019</Fecha>
<Versión>1.0</Versión>
*******************************************************************/
BEGIN TRANSACTION TRA_Insertar_Poliza

BEGIN TRY   		

INSERT INTO [dbo].[POLIZA_SEGUROS]
           ([Nombre]
           ,[Descripcion]
           ,[TipoCubrimiento]
           ,[PeriodoCoberturaMeses]
           ,[PrecioPoliza]
           ,[TipoRiesgo])
     VALUES
           (@psNombre
           ,@psDescripcion
           ,@piTipoCubrimiento
           ,@piPeriodoCoberturaMeses
           ,@pfPrecioPoliza
           ,@piTipoRiesgo)


	--si no hubo error se termina la transacción
	COMMIT TRANSACTION TRA_Insertar_Poliza
END TRY 
BEGIN CATCH
	
	DECLARE @vsMensajeErrorActual VARCHAR(5000) = ERROR_MESSAGE();
	ROLLBACK TRANSACTION TRA_Insertar_Poliza;
    RAISERROR(@vsMensajeErrorActual, 16,0);
END CATCH

GO
/****** Object:  Table [dbo].[CLIENTE]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CLIENTE](
	[Codigo_Cliente] [int] NOT NULL,
	[NombreCliente] [nvarchar](150) NULL,
 CONSTRAINT [PK_CLIENTE] PRIMARY KEY CLUSTERED 
(
	[Codigo_Cliente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[POLIZA_POR_CLIENTE]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POLIZA_POR_CLIENTE](
	[Codigo_Cliente] [int] NOT NULL,
	[Codigo_Poliza] [int] NOT NULL,
	[InicioVigencia] [date] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[POLIZA_SEGUROS]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POLIZA_SEGUROS](
	[CodigoSeguro] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [nvarchar](50) NOT NULL,
	[Descripcion] [nvarchar](500) NOT NULL,
	[TipoCubrimiento] [int] NOT NULL,
	[PrecioPoliza] [float] NOT NULL,
	[TipoRiesgo] [int] NOT NULL,
	[PeriodoCoberturaMeses] [int] NOT NULL,
 CONSTRAINT [PK_POLIZA_SEGUROS] PRIMARY KEY CLUSTERED 
(
	[CodigoSeguro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TIPOS_RIESGO]    Script Date: 16/9/2019 9:12:41 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TIPOS_RIESGO](
	[Codigo] [int] NOT NULL,
	[NombreRiesgo] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TIPOS_RIESGO] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[POLIZA_POR_CLIENTE]  WITH CHECK ADD  CONSTRAINT [FK_POLIZA_POR_CLIENTE_CLIENTE] FOREIGN KEY([Codigo_Cliente])
REFERENCES [dbo].[CLIENTE] ([Codigo_Cliente])
GO
ALTER TABLE [dbo].[POLIZA_POR_CLIENTE] CHECK CONSTRAINT [FK_POLIZA_POR_CLIENTE_CLIENTE]
GO
ALTER TABLE [dbo].[POLIZA_POR_CLIENTE]  WITH CHECK ADD  CONSTRAINT [FK_POLIZA_POR_CLIENTE_POLIZA_SEGUROS] FOREIGN KEY([Codigo_Poliza])
REFERENCES [dbo].[POLIZA_SEGUROS] ([CodigoSeguro])
GO
ALTER TABLE [dbo].[POLIZA_POR_CLIENTE] CHECK CONSTRAINT [FK_POLIZA_POR_CLIENTE_POLIZA_SEGUROS]
GO
ALTER TABLE [dbo].[POLIZA_SEGUROS]  WITH CHECK ADD  CONSTRAINT [FK_POLIZA_SEGUROS_TIPOS_RIESGO] FOREIGN KEY([TipoRiesgo])
REFERENCES [dbo].[TIPOS_RIESGO] ([Codigo])
GO
ALTER TABLE [dbo].[POLIZA_SEGUROS] CHECK CONSTRAINT [FK_POLIZA_SEGUROS_TIPOS_RIESGO]
GO
USE [master]
GO
ALTER DATABASE [TEST_SEGUROS] SET  READ_WRITE 
GO
