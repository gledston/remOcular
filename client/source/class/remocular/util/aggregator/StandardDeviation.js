/* ************************************************************************
   Copyright: 2009, OETIKER+PARTNER AG
   License: GPL
   Authors: Tobias Oetiker
************************************************************************ */

/**
 * Call the server for updates and dispatch the answers
 */
qx.Class.define('remocular.util.aggregator.StandardDeviation', {
    extend : remocular.util.aggregator.Abstract,

    members : {
        /**
         * TODOC
         *
         * @param row {var} TODOC
         * @return {var} TODOC
         */
        process : function(row) {
            var cfg = this._getCfg();
            var sto = this._getStore();
            var key = row[cfg.key_col];
            var value = row[cfg.source_col];

            if (sto[key] == undefined) {
                sto[key] = {
                    count : 0,
                    sum   : 0,
                    sqsum : 0
                };
            }

            var s = sto[key];
            s.count++;
            s.sum += value;
            s.sqsum += (value * value);
            var val = Math.sqrt((s.sqsum - s.sum * s.sum / s.count) / s.count);
            return val;
        }
    }
});