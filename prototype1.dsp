import("stdfaust.lib");
// NAN-safe division
div(x1, x2) = ba.if(x2 == 0, 0, x1 / x2);
// Backwards Euler's integrator with cut-off frequency.
integrator(cf, x) = x * w(cf) :    (+ : (min(1, max(0))))
                                   ~ _
with {
      w(f) = 2 * ma.PI * f / ma.SR;
};
// Averaging function based on a 1-pole lowpass filter and the T19 time
// constant, that is, the system decays by 1/e^2.2 in "frame" seconds.
avg_t19(frame, x) = si.smooth(ba.tau2pole(frame / 2.2), x);
// N-th-order Butterworth crossover. N must be known at compile-time.
xover(N, cf, x) =  fi.lowpass(N, cf1, x) ,
                   fi.highpass(N, cf1, x)
with {
    cf1 = min(max(cf, 20), ma.SR / 2 - 20);
};
// Spectral centroid through N-th-order recursive adaptive filtering. Analysis 
// frame in seconds.
sc(N, frame, x) =  (   (_ ,
                       x) : xover(N) : ro.cross(2) : (rms(frame) - rms(frame)) :
                           div(_, rms(frame, x)) ^ 3 : integrator(1 / frame) ^ 2)
                   ~ *(ma.SR / 2);
// Root mean square. Averaging frame in seconds.
rms(frame, x) = x * x : avg_t19(frame) : sqrt;
// Faust's notch filter for clarity
notch(bw, cf, x) = fi.notchw(bw, cf, x);
gain = hslider("Input gain[scale:exp]", 1, 0, 64, .001);
on = checkbox("Activate");
process(x) = (x * gain : notch(1000, detect) * on + x * gain * (1 - on) <: _ , _) , detect 
with {
    detect = sc(1, .1, x) * ma.SR / 2;
};

