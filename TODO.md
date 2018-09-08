# DONE

## for v0.3 release

* pre-selection of printer --> done
* ask for printer if multiple printer has been found --> done
* pre-selection of SMC --> done
* daemonize it (as in https://codeincomplete.com/posts/ruby-daemons/) --> done

# IN PROGRESS

## for 0.35 solidaritycity release

* add search for hashtag function --> done
* dualmode instant print (mentions/hashtags) and onpush print (infosheet)

# TODO

## for  v0.4 release

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

## v0.4: talk to a remote instance

a json/rest push service to talk w/a control instance (CTRLSRV)
* auth via JWT (json web token)
* send status + stats

receive config updates:
* print mode: all|friends|self (default: all)
* queue length: integer (default: 5)
* msg lifetime (default: 1 week)

## not yet allocated

...