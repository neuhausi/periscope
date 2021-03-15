##
## The code in this file is part of the logging package. The logging package is free
## software: you can redistribute it as well as modify it under the terms of
## the GNU General Public License as published by the Free Software
## Foundation, either version 3 of the License, or (at your option) any later
## version.
##
## this program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## Copyright (c) 2009..2013 by Mario Frasca
##


## create the logging environment
logging.options <- new.env()


## The logging levels, names and values
##
## This list associates names to values and vice versa.\cr
## Names and values are the same as in the python standard logging module.
## 
loglevels <- c(NOTSET = 0,
               FINEST = 1,
               FINER = 4,
               FINE = 7,
               DEBUG = 10,
               INFO = 20,
               WARNING = 30,
               WARN = 30,
               ERROR = 40,
               CRITICAL = 50,
               FATAL = 50)

namedLevel <- function(value)
    UseMethod("namedLevel")

namedLevel.default <- function(value) {
    loglevels[1]
}

namedLevel.character <- function(value) {
    position <- which(names(loglevels) == value)
    if (length(position) == 0) {
        position <- 1
    }
    loglevels[position][1]
}

namedLevel.numeric <- function(value) {
    position <- which(loglevels == value)
    if (length(position) == 0) {
        position <- 1
    }
    loglevels[position][1]
}

Logger <- setRefClass(
    "Logger",
    fields = list(
        name = "character",
        handlers = "list",
        level = "numeric",
        msg_composer = "function"),
    methods = list(
        getParent = function() {
            # split the name on the '.'
            parts <- unlist(strsplit(name, ".", fixed = TRUE))
            removed <- parts[-length(parts)] # except the last item
            parent_name <- paste(removed, collapse = ".")
            return(getLogger(parent_name))
        },
        
        getMsgComposer = function() {
            if (!is.null(msg_composer) && !is.null(functionBody(msg_composer))) {
                return(msg_composer)
            }
            if (name != "") {
                parent_logger <- getParent()
                return(parent_logger$getMsgComposer())
            }
            return(defaultMsgCompose)
        },
        
        setMsgComposer = function(composer_f) {
            if (!is.function(composer_f)
                || paste(formalArgs(composer_f), collapse = ", ") != "msg, ...") {
                stop(paste("message composer(passed as composer_f) must be function",
                           " with signature function(msg, ...)"))
            }
            msg_composer <<- composer_f
        },
        
        .deducelevel = function(initial_level = loglevels[["NOTSET"]]) {
            if (initial_level != loglevels[["NOTSET"]]) {
                # it's proper level (set: Not for inheritance)
                return(initial_level)
            }
            
            if (level != loglevels[["NOTSET"]]) {
                return(level)
            }
            
            if (name == "") {
                # assume it's FINEST, as root logger cannot inherit
                return(loglevels[["FINEST"]])
            }
            
            # ask parent for level
            parent_logger <- getParent()
            return(parent_logger$.deducelevel())
        },
        
        .logrecord = function(record) {
            logger_level <- .deducelevel(level)
            if (record$level >= logger_level) {
                for (handler in handlers) {
                    handler_level <- .deducelevel(with(handler, level))
                    if (record$level >= handler_level) {
                        action <- with(handler, action)
                        formatter <- with(handler, formatter)
                        action(formatter(record), handler, record)
                    }
                }
            }
            
            if (name != "") {
                parent_logger <- getParent()
                parent_logger$.logrecord(record)
            }
            invisible(TRUE)
        },
        
        log = function(msglevel, msg, ...) {
            msglevel <- namedLevel(msglevel)
            if (msglevel < level) {
                return(invisible(FALSE))
            }
            ## fine, we create the record and pass it to all handlers attached to the
            ## loggers from here up to the root.
            record <- list()
            
            composer_f <- getMsgComposer()
            record$msg <- composer_f(msg, ...)
            record$timestamp <- sprintf("%s", Sys.time())
            record$logger <- name
            record$level <- msglevel
            record$levelname <- names(which(loglevels == record$level)[1])
            
            ## cascade action in private method.
            .logrecord(record)
        },
        
        setLevel = function(new_level) {
            new_level <- namedLevel(new_level)
            level <<- new_level
        },
        
        getLevel = function() level,
        
        getHandler = function(handler) {
            if (!is.character(handler))
                handler <- deparse(substitute(handler))
            handlers[[handler]]
        },
        
        removeHandler = function(handler) {
            if (!is.character(handler))  # handler was passed as its action
                handler <- deparse(substitute(handler))
            handlers <<- handlers[!(names(handlers) == handler)]
        },
        
        addHandler = function(handler, ..., level = 0, formatter = defaultFormat) {
            handler_env <- new.env()
            if (is.character(handler)) {
                ## first parameter is handler name
                handler_name <- handler
                ## and hopefully action is in the dots
                params <- list(...)
                if ("action" %in% names(params)) {
                    the_action <- params[["action"]]
                } else if (length(params) > 0 && is.null(names(params)[[1]])) {
                    the_action <- params[[1]]
                } else {
                    stop("No action for the handler provided")
                }
                
                assign("action", the_action, handler_env)
            } else {
                ## first parameter is handler action, from which we extract the name
                updateOptions.environment(handler_env, action = handler)
                handler_name <- deparse(substitute(handler))
            }
            updateOptions.environment(handler_env, ...)
            assign("level", namedLevel(level), handler_env)
            assign("formatter", formatter, handler_env)
            removeHandler(handler_name)
            
            if (with(handler_env, action)(NA, handler_env, dry = TRUE) == TRUE) {
                handlers[[handler_name]] <<- handler_env
            }
        },
        
        finest = function(...) log(loglevels["FINEST"], ...),
        finer = function(...) log(loglevels["FINER"], ...),
        fine = function(...) log(loglevels["FINE"], ...),
        debug = function(...) log(loglevels["DEBUG"], ...),
        info = function(...) log(loglevels["INFO"], ...),
        warn = function(...) log(loglevels["WARN"], ...),
        error = function(...) log(loglevels["ERROR"], ...)
    ) # methods
) # setRefClass



#' Entry points for logging actions
#'
#' Generate a log record and pass it to the logging system.\cr
#'
#' A log record gets timestamped and will be independently formatted by each
#' of the handlers handling it.\cr
#'
#' Leading and trailing whitespace is stripped from the final message.
#'
#' @param msg the textual message to be output, or the format for the \dots
#'  arguments
#' @param ... if present, msg is interpreted as a format and the \dots values
#'  are passed to it to form the actual message.
#' @param logger the name of the logger to which we pass the record
#'
#' @name logging-entrypoints
#' @importFrom methods new
#'
NULL


#' @rdname logging-entrypoints
#' @export
logdebug <- function(msg, ..., logger = "") {
    .levellog(loglevels["DEBUG"], msg, ..., logger = logger)
}

## @rdname logging-entrypoints
logfinest <- function(msg, ..., logger = "") {
    .levellog(loglevels["FINEST"], msg, ..., logger = logger)
}

## @rdname logging-entrypoints
logfiner <- function(msg, ..., logger = "") {
    .levellog(loglevels["FINER"], msg, ..., logger = logger)
}

## @rdname logging-entrypoints
logfine <- function(msg, ..., logger = "") {
    .levellog(loglevels["FINE"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
loginfo <- function(msg, ..., logger = "") {
    .levellog(loglevels["INFO"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
logwarn <- function(msg, ..., logger = "") {
    .levellog(loglevels["WARN"], msg, ..., logger = logger)
}

#' @rdname logging-entrypoints
#' @export
logerror <- function(msg, ..., logger = "") {
    .levellog(loglevels["ERROR"], msg, ..., logger = logger)
}

## @rdname logging-entrypoints
## @param level The logging level
levellog <- function(level, msg, ..., logger = "") {
    # just calling .levellog
    # do not simplify it as call sequence sould be same
    #   as for other logX functions
    .levellog(level, msg, ..., logger = logger)
}

.levellog <- function(level, msg, ..., logger = "") {
    if (is.character(logger)) {
        logger <- getLogger(logger)
    }
    logger$log(level, msg, ...)
}



##
## Set defaults and get the named logger.
##
## Make sure a logger with a specific name exists and return it as a
## \var{Logger} S4 object.  if not yet present, the logger will be created and
## given the values specified in the \dots arguments.
## @importFrom methods new
## @param name The name of the logger
## @param ... Any properties you may want to set in the newly created
##    logger. These have no effect if the logger is already present.
##
## @return The logger retrieved or registered.
getLogger <- function(name = "", ...) {
    if (name == "") {
        fullname <- "logging.ROOT"
    } else {
        fullname <- paste("logging.ROOT", name, sep = ".")
    }
    
    if (!exists(fullname, envir = logging.options)) {
        logger <- Logger$new(name = name,
                             handlers = list(),
                             level = namedLevel("NOTSET"))
        updateOptions.environment(logger, ...)
        logging.options[[fullname]] <- logger
        
        if (fullname == "logging.ROOT") {
            .basic_config(logger)
        }
    }
    logging.options[[fullname]]
}



##
## Bootstrapping the logging package.
##
## \code{basicConfig} and \code{logReset} provide a way to put the logging package
## in a know initial state.
##
## @name bootstrapping
## NULL

## @rdname bootstrapping
##
## @details
## \code{basicConfig} creates the root logger, attaches a console handler(by
## \var{basic.stdout} name) to it and sets the level of the handler to
## \code{level}. You must not call \code{basicConfig} to for logger to work any more:
## then root logger is created it gets initialized by default the same way as
## \code{basicConfig} does. If you need clear logger to fill with you own handlers
## use \code{logReset} to remove all default handlers.
##
## @param level The logging level of the root logger. Defaults to INFO. Please do notice that
##   this has no effect on the handling level of the handler that basicConfig attaches to the
##   root logger.
##
##
basicConfig <- function(level = 20) {
    root_logger <- getLogger()
    
    updateOptions(root_logger, level = namedLevel(level))
    .basic_config(root_logger)
    
    invisible()
}

## Called from basicConfig and while creating rootLogger.
## @noRd
.basic_config <- function(root_logger) {
    stopifnot(root_logger$name == "")
    root_logger$addHandler("basic.stdout", writeToConsole)
}


## @rdname bootstrapping
##
## @details
## \code{logReset} reinitializes the whole logging system as if the package had just been
## loaded except it also removes all default handlers. Typically, you would want to call
## \code{basicConfig} immediately after a call to \code{logReset}.
##
## 
##
logReset <- function() {
    ## reinizialize the whole logging system
    
    ## remove all content from the logging environment
    rm(list = ls(logging.options), envir = logging.options)
    
    root_logger <- getLogger(level = "NOTSET")
    root_logger$removeHandler("basic.stdout")
    
    invisible()
}



##
## Add a handler to or remove one from a logger.
##
## Use this function to maintain the list of handlers attached to a logger.\cr
## \cr
## \code{addHandler} and \code{removeHandler} are also offered as methods of the
## \var{Logger} S4 class.
##
## @details
## Handlers are implemented as environments. Within a logger a handler is
## identified by its \var{name} and all handlers define at least the
## three variables:
## \describe{
##   \item{level}{all records at level lower than this are skipped.}
##   \item{formatter}{a function getting a record and returning a string}
##   \item{\code{action(msg, handler)}}{a function accepting two parameters: a
##      formatted log record and the handler itself. making the handler a
##      parameter of the action allows us to have reusable action functions.}
## }
##
## Being an environment, a handler may define as many variables as you
## think you need.  keep in mind the handler is passed to the action
## function, which can check for existence and can use all variables that
## the handler defines.
##
## @param handler The name of the handler, or its action
## @param logger the name of the logger to which to attach the new handler,
##   defaults to the root logger.
##
## @name handlers-management
## NULL


## @rdname handlers-management
##
## @param ... Extra parameters, to be stored in the handler list
##
## \dots may contain extra parameters that will be passed to the handler
## action. Some elements in the \dots will be interpreted here.
##
## 
##
addHandler <- function(handler, ..., logger = "") {
    if (is.character(logger)) {
        logger <- getLogger(logger)
    }
    
    ## this part has to be repeated here otherwise the called function
    ## will deparse the argument to 'handler', the formal name given
    ## here to the parameter
    if (is.character(handler)) {
        logger$addHandler(handler, ...)
    } else {
        handler_name <- deparse(substitute(handler))
        logger$addHandler(handler = handler_name, action = handler, ...)
    }
}

## @rdname handlers-management
## 
##
removeHandler <- function(handler, logger = "") {
    if (is.character(logger)) {
        logger <- getLogger(logger)
    }
    if (!is.character(handler)) {
        # handler was passed as its action
        handler <- deparse(substitute(handler))
    }
    logger$removeHandler(handler)
}

##
## Retrieves a handler from a logger.
##
## @description
## Handlers are not uniquely identified by their name. Only within the logger to which
## they are attached is their name unique. This function is here to allow you grab a
## handler from a logger so you can examine and alter it.
##
## @description
## Typical use of this function is in \code{setLevel(newLevel, getHandler(...))}.
##
## @param handler The name of the handler, or its action.
## @param logger Optional: the name of the logger. Defaults to the root logger.
##
## @return The retrieved handler object. It returns NULL if handler is not registered.
getHandler <- function(handler, logger = "") {
    if (is.character(logger)) {
        logger <- getLogger(logger)
    }
    if (!is.character(handler)) {
        # handler was passed as its action
        handler <- deparse(substitute(handler))
    }
    logger$getHandler(handler)
}



##
## Set \var{logging.level} for the object.
##
## Alter an existing logger or handler, setting its \var{logging.level} to a new
## value. You can access loggers by name, while you must use \code{getHandler} to
## get a handler.
##
## @param level The new level for this object. Can be numeric or character.
## @param container a logger, its name or a handler. Default is root logger.
##
setLevel <- function(level, container = "") {
    if (is.null(container)) {
        stop("NULL container provided: cannot set level for NULL container")
    }
    
    if (is.character(container)) {
        container <- getLogger(container)
    }
    assign("level", namedLevel(level), container)
}

##
## Sets message composer for logger.
##
## Message composer is used to compose log message out of formatting string and arguments.
## It is function with signature \code{function(msg, ...)}. Formatting message is passed under msg
## and formatting arguments are passed as \code{...}.
##
## If message composer is not set default is in use (realized with \code{sprintf}). If message
## composer is not set for sub-logger, parent's message composer will be used.
##
## @param composer_f message composer function (type: function(msg, ...))
## @param container name of logger to reset message composer for (type: character)
##
setMsgComposer <- function(composer_f, container = "") {
    if (is.null(container)) {
        stop("NULL container provided: cannot set message composer for NULL container")
    }
    
    if (is.character(container)) {
        container <- getLogger(container)
    }
    container$setMsgComposer(composer_f)
    assign("msg_composer", composer_f, container)
}

##
## Resets previously set message composer.
##
## @param container name of logger to reset message composer for (type: character)
## 
resetMsgComposer <- function(container = "") {
    if (is.null(container)) {
        stop("NULL container provided: cannot resset message composer for NULL container")
    }
    
    if (is.character(container)) {
        container <- getLogger(container)
    }
    assign("msg_composer", function() NULL, container)
}

##
## Changes settings of logger or handler.
##
## @param container a logger, its name or a handler.
## @param ... options to set for the container.
##
updateOptions <- function(container, ...)
    UseMethod("updateOptions")

## @describeIn updateOptions Update options for logger identified by name.
## 
updateOptions.character <- function(container, ...) {
    ## container is really just the name of the container
    updateOptions(getLogger(container), ...)
}

## @describeIn updateOptions Update options of logger or handler passed by reference.
## 
updateOptions.environment <- function(container, ...) {
    ## the container is a logger
    config <- list(...)
    if ("level" %in% names(config)) {
        config$level <- namedLevel(config$level)
    } else if (get("name", container) == "") {
        # root logger
        config$level <- loglevels["NOTSET"]
    } else {
        config$level <- loglevels["NOTSET"]
    }
    
    for (key in names(config)) {
        if (key != "") {
            assign(key, config[[key]], container)
        }
    }
    invisible()
}

## @describeIn updateOptions Update options of logger or handler passed by reference.
##   
updateOptions.Logger <- function(container, ...) {
    updateOptions.environment(container, ...)
}

##
## Predefined(sample) handler actions
##
## When you define a handler, you specify its name and the associated action.
## A few predefined actions described below are provided.
##
## A handler action is a function that accepts a formatted message and handler
## configuration.
##
## Messages passed are filtered already regarding loglevel.
##
## \dots parameters are used by logging system to interact with the action. \dots can
## contain \var{dry} key to inform action that it meant to initialize itself. In the case
## action should return TRUE if initialization succeeded.
##
## If it's not a dry run \dots contain the whole preformatted \var{logging.record}.
## A \var{logging.record} is a named list and has following structure:
## \describe{
##   \item{msg}{contains the real formatted message}
##   \item{level}{message level as numeric}
##   \item{levelname}{message level name}
##   \item{logger}{name of the logger that generated it}
##   \item{timestamp}{formatted message timestamp}
## }
##
## @param msg A formatted message to handle.
## @param handler The handler environment containing its options. You can
##   register the same action to handlers with different properties.
## @param ... parameters provided by logger system to interact with the action.
##
## @examples
## ## define your own function and register it with a handler.
## ## author is planning a sentry client function.  please send
## ## any interesting function you may have written!
##
## @name inbuilt-actions
## NULL

## @rdname inbuilt-actions
##
## @details
## \code{writeToConsole} detects if crayon package is available and uses it
## to color messages. The coloring can be switched off by means of configuring
## the handler with \var{color_output} option set to FALSE.
## 
writeToConsole <- function(msg, handler, ...) {
    if (length(list(...)) && "dry" %in% names(list(...))) {
        if (!is.null(handler$color_output) && handler$color_output == FALSE) {
            handler$color_msg <- function(msg, level_name) msg
        } else {
            handler$color_msg <- .build_msg_coloring()
        }
        return(TRUE)
    }
    
    stopifnot(length(list(...)) > 0)
    
    level_name <- list(...)[[1]]$levelname
    msg <- handler$color_msg(msg, level_name)
    cat(paste0(msg, "\n"))
}

.build_msg_coloring <- function() {
    crayon_env <- tryCatch(asNamespace("crayon"),
                           error = function(e) NULL)
    
    default_color_msg <- function(msg, level_name) msg
    if (is.null(crayon_env)) {
        return(default_color_msg)
    }
    
    if (is.null(crayon_env$make_style) ||
        is.null(crayon_env$combine_styles) ||
        is.null(crayon_env$reset)) {
        return(default_color_msg)
    }
    
    color_msg <- function(msg, level_name) {
        style <- switch(level_name,
                        "FINEST" = crayon_env$make_style("gray80"),
                        "FINER" = crayon_env$make_style("gray60"),
                        "FINE" = crayon_env$make_style("gray60"),
                        "DEBUG" = crayon_env$make_style("deepskyblue4"),
                        "INFO" = crayon_env$reset,
                        "WARNING" = crayon_env$make_style("darkorange"),
                        "ERROR" = crayon_env$make_style("red4"),
                        "CRITICAL" =
                            crayon_env$combine_styles(crayon_env$bold,
                                                      crayon_env$make_style("red1")),
                        crayon_env$make_style("gray100"))
        res <- paste0(style(msg), crayon_env$reset(""))
        return(res)
    }
    return(color_msg)
}


## @rdname inbuilt-actions
##
## @details \code{writeToFile} action expects file path to write to under
##  \var{file} key in handler options.
##  
writeToFile <- function(msg, handler, ...) {
    if (length(list(...)) && "dry" %in% names(list(...)))
        return(exists("file", envir = handler))
    cat(paste0(msg, "\n"), file = with(handler, file), append = TRUE)
}

## the single predefined formatter
defaultFormat <- function(record) {
    ## strip leading and trailing whitespace from the final message.
    msg <- trimws(record$msg)
    text <- paste(record$timestamp,
                  paste(record$levelname, record$logger, msg, sep = ":"))
    return(text)
}

## default way of composing msg with parameters
defaultMsgCompose <- function(msg, ...) {
    optargs <- list(...)
    if (is.character(msg)) {
        ## invoked as ("printf format", arguments_for_format)
        if (length(optargs) > 0) {
            optargs <- lapply(optargs,
                              function(x) {
                                  if (length(x) != 1)
                                      x <- paste(x, collapse = ",")
                                  x
                              })
        }
        
        # 8192 is limitation on fmt in sprintf
        if (any(nchar(msg) > 8192)) {
            if (length(optargs) > 0) {
                stop("'msg' length exceeds maximal format length 8192")
            }
            
            # else msg must not change in any way
            return(msg)
        }
        if (length(optargs) > 0) {
            msg <- do.call("sprintf", c(msg, optargs))
        }
        return(msg)
    }
    
    ## invoked as list of expressions
    ## this assumes that the function the user calls is two levels up, e.g.:
    ## loginfo -> .levellog -> logger$log -> .default_msg_composer
    ## levellog -> .levellog -> logger$log -> .default_msg_composer
    external_call <- sys.call(-3)
    external_fn <- eval(external_call[[1]])
    matched_call <- match.call(external_fn, external_call)
    matched_call <- matched_call[-1]
    matched_call_names <- names(matched_call)
    
    ## We are interested only in the msg and ... parameters,
    ## i.e. in msg and all parameters not explicitly declared
    ## with the function
    formal_names <- names(formals(external_fn))
    is_output_param <-
        matched_call_names == "msg" |
        !(matched_call_names %in% c(setdiff(formal_names, "...")))
    
    label <- lapply(matched_call[is_output_param], deparse)
    msg <- sprintf("%s: %s", label, c(msg, optargs))
    return(msg)
}
