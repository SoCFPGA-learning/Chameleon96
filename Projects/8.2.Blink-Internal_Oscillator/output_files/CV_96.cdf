/* Quartus Prime Version 20.1.0 Build 711 06/05/2020 SJ Standard Edition */
JedecChain;
	FileRevision(JESD32A);
	DefaultMfr(6E);

	P ActionCode(Ign)
		Device PartName(SOCVHPS) MfrSpec(OpMask(0));
	P ActionCode(Cfg)
		Device PartName(5CSEBA6U19) Path("D:/Wrk/FPGA/Chamaleon96/Blink-InternalOSC/output_files/") File("CV_96.sof") MfrSpec(OpMask(1));

ChainEnd;

AlteraBegin;
	ChainType(JTAG);
AlteraEnd;
