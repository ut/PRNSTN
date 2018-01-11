# DONE

## for v0.3 release

* pre-selection of printer --> done
* ask for printer if multiple printer has been found
* pre-selection of SMC

# TODO

## for  v0.3 release

* daemonize it
* test web servives w/VCR

add to message queue:
* poll for new messages via smc api
* sort and store messages (depending of config  mode)
* error handling routines


robust error handling functions
* no net access
* no logfile writeable
* no printer
* social media api not reachable
* remote CTRLSRV not reachable

## v0.4: talk to a remote instance

a json/rest push service to talk w/a control instance (CTRLSRV)
* auth via JWT (jso web token)
* send status + stats


receive config updates:
* print mode: all|friends|self (default: all)
* queue length: integer (default: 5)
* msg lifetime (default: 1 week)

## not yet allocated
