import iteso.dispositivoElectronico.*;

public class TestDispositivoElectronico {

	public static void main(String[] args) {
		//CREAR UN CELULAR
		System.out.println("////// CREACION DE CELULAR //////");
		Celular a1 = new Celular();
		System.out.println(a1);

		a1.encender();
		a1.setBateria(5);
		a1.setSistemaOperativo(DispositivoElectronico.IOS);
		a1.instalarAplicacion("Google Maps");
		a1.instalarAplicacion("YouTube");
		a1.instalarAplicacion("Google Maps");
		a1.conectarCorriente();
		a1.setTamaño(6);
		a1.desconectarCorriente();
		a1.setWifi(Wifi.WIFI5);
		a1.setMarca(DispositivoElectronico.APPLE);
		System.out.println(a1);

		a1.setBateria(4);
		a1.llamar();
		a1.setWifi(Wifi.RED_5G);
		a1.eliminarAplicacion("Discord");
		a1.eliminarAplicacion("YouTube");
		System.out.println(a1);
		
		//CREAR UNA TABLET
		System.out.println("\n\n////// CREACION DE UNA TABLET //////");
		Tablet a2 = new Tablet();
		System.out.println(a2);
		
		a2.encender();
		a2.setBateria(10);
		a2.setSistemaOperativo(DispositivoElectronico.ANDROID);
		a2.instalarAplicacion("Google Maps");
		a2.instalarAplicacion("YouTube");
		a2.instalarAplicacion("Netflix");
		a2.instalarAplicacion("Twitch");
		a2.setTamaño(6);
		a2.desconectarCorriente();
		a2.setWifi(Wifi.WIFI6);
		a2.setMarca(DispositivoElectronico.SAMSUNG);
		System.out.println(a2);
		
		//CREAR UNA LAPTOP
		System.out.println("\n\n////// CREACION DE UNA LAPTOP //////");
		Laptop a3 = new Laptop();
		System.out.println(a3);
		
		a3.encender();
		a3.setBateria(10);
		a3.setSistemaOperativo(DispositivoElectronico.WINDOWS);
		a3.instalarAplicacion("Google Maps");
		a3.instalarAplicacion("YouTube");
		a3.instalarAplicacion("Google Chorme");
		a3.instalarAplicacion("Notas");
		a3.setTamaño(10);
		a3.desconectarCorriente();
		a3.setWifi(Wifi.WIFI6);
		a3.conectarEthernet();
		a3.setVelocidad(Ethernet.VEL1000Mbps);
		a3.setMarca(DispositivoElectronico.HP);
		System.out.println(a2);

	}

}
