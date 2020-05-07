import("stdfaust.lib");
import("detection.lib");
import("suppression.lib");
// signal inspector
inspect(i, lower, upper) = _ <: attach(_ ,
                                       _ : vbargraph("sig_%i [style:numerical]",
                                                       lower,
                                                       upper));

peak_tracker(N, frame, x) =     ((  _ , 
                                    (_,0.1,x:bpbi)) : xover(N) : ro.cross(2) : (rms(frame) - rms(frame)) :
                                        div(_, rms(frame, x)) ^ 3 : integrator(1 / frame) ^ 2)
                                            * (ma.SR / 2)
                                ~ (_ <: _,_);
pt2(N, frame, x) = (_, hslider("q", 1, 0, 100, .001), x : bpbi <: sc(N, frame), _) ~ _;
test = no.noise <: par(i, 4, bpbi(hslider("cf%i", 1000, 0, 20000, .001), hslider("q%i", 1, 0, 100, .001))) :> _/(rms(1));
// process = test + os.osc(hslider("osc", 10000, 0, 20000, .001)) <: 
//     _ , 
//     (dt.sc(1, 1) : inspect(0, 0, 20000)) , 
//     (bpbi(hslider("masterCF", 1000, 0, 20000, .001), hslider("masterQ", 1, 0, 100, .001)) <: _ , (dt.sc(1, 1) : inspect(1, 0, 20000)));
//process = no.noise : peak_tracker(2, 1);
process = bpbi(1000, 1, no.noise) <: (_/rms(.1))/2 + os.osc(10000)*1 <: sc(1, .1) , _ , pt2(1, .1);
//process = no.noise : bpbi(hslider("cf[scale:exp]", 0, 0, 20000, .001), hslider("q[scale:exp]", 1, 0, 10, .001)) : sc(2, 1);
