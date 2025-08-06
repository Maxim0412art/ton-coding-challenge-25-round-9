const MY_WORKCHAIN = BASECHAIN;
const OP_START = stringCrc32("start"); // 4ff2aa38
const OP_RESET = stringCrc32("reset"); // 83ad9f01

var timer: int = 0;

fun startTimer() {
    timer = now();
}

fun resetTimer() {
    timer = 0;
}

fun routeInternal(`ctx::sender`: slice, `ctx::value`: int, `ctx::fwd_fee`: int, `ctx::body`: slice) {
    var (op: int, _) = `ctx::body`.loadOpAndQueryId();

    if (op == OP_START) {
        startTimer();
        return;
    }

    if (op == OP_RESET) {
        resetTimer();
        return;
    }

    throw 0xffff;
}

fun main(`ctx::value`: int, inMsgFull: cell, `ctx::body`: slice) {
    var s = inMsgFull.beginParse();
    var flags = s.loadMsgFlags();
    if (isBounced(flags)) { return; }

    var (`ctx::sender`: slice, `ctx::fwd_fee`: int) = s.retrieveCtx(MY_WORKCHAIN);
    routeInternal(`ctx::sender`, `ctx::value`, `ctx::fwd_fee`, `ctx::body`);
}
