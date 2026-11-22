*NMOS characterization

.param gs=0.7
.param dd=1.8
vds d 0 dc 'dd/2'
vgs g 0 dc 'gs'
mn d g 0 0 nfet L=0.18um W=5um

.op
.dc gs 0.2V 1V 10mV
.probe ov = par('gs-vth(mn)')
.probe gm_id = par('gmo(mn)/i(mn)')
.probe ft = par('1/6.28*gmo(mn)/cggbo(mn)')
.probe gm_gds = par('gmo(mn)/gdso(mn)')

.options post brief dccap
.end
