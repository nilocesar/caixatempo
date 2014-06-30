package  {
import flash.display.MovieClip;
import flash.system.Security;

[SWF(width = "875", height = "520", backgroundColor="#FFFFFF",  frameRate = "31")]

public class AppClient extends MovieClip {	
	
    public function AppClient() {
        Security.allowDomain("*");
        Security.allowInsecureDomain("*");
		//Security.loadPolicyFile( "http://<EC2 internal IP or public DNS>/crossdomain.xml" );
		
        init();
    }

    public function init():void {
        addChild(Main.instance);
    }
}
}