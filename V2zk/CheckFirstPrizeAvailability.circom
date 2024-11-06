pragma circom 2.0.0;

template CheckFirstPrizeAvailability() {
    signal input prizes[10];
    signal input soldStatus[10];
    signal input targetPrize;
    signal output isAvailable;

    signal output prizeInUnsoldStar[11];
//    signal m1;
//    signal m2;

    prizeInUnsoldStar[0] <==0;
    component prizeChecks[10];
    for (var i = 0; i < 10; i++) {
        prizeChecks[i] = IsEqual();
        prizeChecks[i].in[0] <== prizes[i];
        prizeChecks[i].in[1] <== targetPrize;

        prizeInUnsoldStar[i+1] <== prizeInUnsoldStar[i]+(prizeChecks[i].out * (1 - soldStatus[i]));
    }

    component checkava=IsEqual();
    checkava.in[0] <== prizeInUnsoldStar[10];
    checkava.in[1] <== 0;

    isAvailable <== checkava.out;

}

template IsEqual() {
    signal input in[2];
    signal output out;
    out <== 1 - (in[0] - in[1]) * (in[0] - in[1]);
}


component main = CheckFirstPrizeAvailability();
