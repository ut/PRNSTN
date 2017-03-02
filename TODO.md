TODO

v0.2

* a social media connector (smc) to receive msgs from different systems
* a message queue
** poll for new messages via smc api
** sort and store messages (depending of config  mode)
* error handling routines

v0.3

* a json/rest push service to talk w/a control instance (CTRLSRV)
** auth via JWT (jso web token)
** send status + stats
** receive config updates:
*** print mode: all|friends|self (default: all)
*** queue length: integer (default: 5)
*** msg lifetime (default: 1 week)


error handling functions

* no net access
* no logfile writeable
* no printer
* social media api not reachable
* remote CTRLSRV not reachable