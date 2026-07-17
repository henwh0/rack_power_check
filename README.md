EX. Output


```text

+------------------------------------------------------------+
| Switchname: rsw_name
| Rack Type:  ORV2
+------------------------------------------------------------+
| Number of powershelves: 2 (serf get)
+------------------------------------------------------------+
| POWER_SHELF	POWER SHELF, V2 12.5V 6.6KW, DELTA, SHORT
| POWER_SHELF	POWER SHELF, V2 12.5V 6.6KW, DELTA, SHORT
+------------------------------------------------------------+
| or_check assets:
+------------------------------------------------------------+
| Shelf-2, Unit-1  164      ACTIVE  19200     0          0         0           277.609   12.552     109.109    50.81        True    True
| Shelf-2, Unit-2  165      ACTIVE  19200     0          0         0           276.609   12.55      110.703    51.202       True    True
| Shelf-2, Unit-3  166      ACTIVE  19200     0          0         0           283.125   12.556     106.906    52.372       True    True
| Shelf-1, Unit-1  180      ACTIVE  19200     0          0         0           278.016   12.548     119.109    50.889       True    True
| Shelf-1, Unit-2  181      ACTIVE  19200     0          0         0           278.109   12.543     120.5      51.436       True    True
| Shelf-1, Unit-3  182      ACTIVE  19200     0          0         0           282.516   12.546     118.906    51.099       True    True
+------------------------------------------------------------+
| Summary:
|   Units present: 6 / 6 expected
|   PSU healthy:   6 / 6
|   BBU healthy:   6 / 6
+------------------------------------------------------------+
|  All PSUs/BBUs are present and healthy.
+------------------------------------------------------------+
| Run Complete!
+------------------------------------------------------------+


--------------------------------------------------------------------------------

+------------------------------------------------------------+
| Switchname: rsw_name
| Rack Type:  ORV3
+------------------------------------------------------------+
| Number of powershelves: 2 (serf get)
+------------------------------------------------------------+
| POWER_SHELF	POWER SHELF, BBU SHELF, V3, 48V, 15KW, PANASONIC/ARTESYN
| POWER_SHELF	POWER SHELF, V3, NEMA, DUAL INPUT, 200-277 VIN / 346-480 VIN, 48-50 VOUT 18KW, ARTESYN
+------------------------------------------------------------+
| or_check assets:
+------------------------------------------------------------+
| Shelf-1, BBU-1  96       2426B1V3PAM10619  ACTIVE  19200     0          0         0           -         -          -          43.99        True
| Shelf-1, BBU-2  97       2426B1V3PAM10628  ACTIVE  19200     0          0         0           -         -          -          43.72        True
| Shelf-1, BBU-3  98       2426B1V3PAM10629  ACTIVE  19200     0          0         0           -         -          -          43.76        True
| Shelf-1, BBU-4  99       2426B1V3PAM10620  ACTIVE  19200     0          0         0           -         -          -          43.97        True
| Shelf-1, BBU-5  100      2426B1V3PAM10621  ACTIVE  19200     0          0         0           -         -          -          43.79        True
| Shelf-1, BBU-6  101      2426B1V3PAM10630  ACTIVE  19200     0          0         0           -         -          -          43.74        True
| Shelf-1, PSU-1  232      0426P1V3AEL00204  ACTIVE  19200     0          0         0           245       50.88      17.625     -            True
| Shelf-1, PSU-2  233      0426P1V3AEL03240  ACTIVE  19200     0          0         0           244       50.909     15.594     -            True
| Shelf-1, PSU-3  234      0426P1V3AEL03407  ACTIVE  19200     0          0         0           245       50.88      15.75      -            True
| Shelf-1, PSU-4  235      0426P1V3AEL03248  ACTIVE  19200     0          0         0           245       50.869     15.531     -            True
| Shelf-1, PSU-5  236      0426P1V3AEL03269  ACTIVE  19200     0          0         0           243       50.92      15.891     -            True
| Shelf-1, PSU-6  237      0426P1V3AEL03237  ACTIVE  19200     0          0         0           245       50.92      15.266     -            True
+------------------------------------------------------------+
| Summary:
|   Units present: 12 / 12 expected
|   PSU found: 6 / 6 expected
|   BBU found: 6 / 6 expected
+------------------------------------------------------------+
|  All PSUs/BBUs are present and healthy.
+------------------------------------------------------------+
| Run Complete!
+------------------------------------------------------------+
