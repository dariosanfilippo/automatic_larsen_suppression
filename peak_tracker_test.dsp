import("stdfaust.lib");
import("detection.lib");
// signal inspector
inspect(i, lower, upper) = _ <: attach(_ ,
                                       _ : vbargraph("sig_%i [style:numerical]",
                                                       lower,
                                                       upper));
// angular frequency
w(f) = 2 * ma.PI * f / ma.SR;
// biquad section
biquad(a0, a1, a2, b1, b2, x) = fir : + ~ iir
with {
      fir = a0*x+a1*x'+a2*x'';
      iir(fb) = -b1*fb-b2*fb';
};
// biquad bandpass (design by Robert Bristow-Johnson)
bpbi(cf, q, in) = biquad(a0, a1, a2, b1, b2, in)
with {
      cf1 = max(5, min(ma.SR / 2 - 5, cf));
      q1 = max(q, .001);
      alpha = sin(w(cf1))/(2*q1);
      norm = 1+alpha;
      a0 = alpha/norm;
      a1 = 0;
      a2 = -alpha/norm;
      b1 = cos(w(cf1))*-2/norm;
      b2 = (1-alpha)/norm;
};
test = no.noise <: par(i, 4, bpbi(hslider("cf%i", 1000, 0, 20000, .001), hslider("q%i", 1, 0, 100, .001))) :> _/(rms(1));
process = test + os.osc(hslider("osc", 10000, 0, 20000, .001)) <: _ , (dt.sc(1, 1) : inspect(0, 0, 20000)) , (bpbi(hslider("masterCF", 1000, 0, 20000, .001), hslider("masterQ", 1, 0, 100, .001)) <: _ , (dt.sc(1, 1) : inspect(1, 0, 20000)));
