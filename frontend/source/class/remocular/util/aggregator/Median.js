/* ************************************************************************
   Copyright: 2009 OETIKER+PARTNER AG 
   License:   GPLv3 or later
   Authors:   Tobi Oetiker <tobi@oetiker.ch>
   Utf8Check: äöü
************************************************************************ */

/**
 * Find the median. Configuration map:
 * <pre class="javascript">
 * cfg = {
 *    key_col: column with the key values
 *    source_col: column with the input data for the average
 * }
 * </pre>
 */
qx.Class.define('remocular.util.aggregator.Median', {
    extend : remocular.util.aggregator.Abstract,

    members : {
        process : function(row) {
            var cfg = this._getCfg();
            var sto = this._getStore();
            var key = row[cfg.key_col];
            var value = row[cfg.source_col];

            if (sto[key] == undefined) {
                sto[key] = [];
            }

            var s = sto[key];
            s.push(value);

            s.sort(function(a, b) {
                return (b - a);
            });

            var x = s.length;
            var ret;

            if (x % 2 == 0) {
                ret = (s[x / 2] + s[x / 2 - 1]) / 2;
            } else {
                ret = s[x / 2 - 0.5];
            }

            return ret;
        }
    }
});
