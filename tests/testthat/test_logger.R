context("periscope - logging functionality")


writeToConsole <- periscope:::writeToConsole
writeToFile    <- periscope:::writeToFile
loglevels      <- periscope:::loglevels
test_file_name <- file.path(tempdir(), c("1", "2", "3"))

env_setup <- function() {
    test_env <- new.env(parent = emptyenv())
    test_env$logged <- NULL
    
    mock_action <- function(msg, handler, ...) {
        if (length(list(...)) && "dry" %in% names(list(...)))
            return(TRUE)
        test_env$logged <- c(test_env$logged, msg)
    }
    
    mock_formatter <- function(record) {
        paste(record$levelname, record$logger, record$msg, sep = ":")
    }
    
    periscope:::logReset()
    periscope:::addHandler(mock_action,
                           formatter = mock_formatter)
    return(test_env)
}

test_that("Handlers - addHandler(), getHandler() and removeHandler()", {
    periscope:::logReset()
    periscope:::basicConfig()
    
    # looking for handler in RootLogger
    expect_identical(periscope:::getHandler("basic.stdout"),
                     periscope:::getLogger()[["handlers"]][[1]])
    # looking for handler in object
    expect_identical(periscope:::getLogger()$getHandler("basic.stdout"),
                     periscope:::getLogger()[["handlers"]][[1]])
    
    # add handler
    periscope:::addHandler(writeToConsole)
    
    expect_equal(length(with(periscope:::getLogger(), names(handlers))), 2)
    expect_true("writeToConsole" %in% with(periscope:::getLogger(), names(handlers)))
    
    # get handler
    expect_true(!is.null(periscope:::getHandler("writeToConsole")))
    expect_true(!is.null(periscope:::getHandler(writeToConsole)))
    
    # remove handler
    periscope:::removeHandler("writeToConsole")
    expect_equal(length(with(periscope:::getLogger(), names(handlers))), 1)
    expect_false("writeToConsole" %in% with(periscope:::getLogger(), names(handlers)))
    
    expect_error(periscope:::addHandler("handlerName"),
                 regexp = "No action for the handler provided",
                 fixed = TRUE)
})

test_that("Handlers in Logger object - addHandler(), getHandler() and removeHandler()", {
    periscope:::logReset()
    periscope:::basicConfig()
    
    # add handler
    log <- periscope:::getLogger("testLogger")
    log$addHandler(writeToConsole)
    expect_equal(length(with(log, names(handlers))), 1)
    
    # get handler
    expect_true(!is.null(log$getHandler("writeToConsole")))
    expect_true(!is.null(log$getHandler(writeToConsole)))
    
    # remove handler
    log$removeHandler(writeToConsole)
    expect_equal(length(with(log, names(handlers))), 0)
    expect_false("writeToConsole" %in% with(log, names(handlers)))
})

test_that("Levels - setLevel()", {
    periscope:::logReset()
    periscope:::basicConfig()
    
    expect_error(periscope:::setLevel("INFO", NULL),
                 regexp = "NULL container provided: cannot set level for NULL container",
                 fixed = TRUE)
    
    periscope:::logReset()
    expect_equal(periscope:::setLevel(TRUE), loglevels["NOTSET"]) # invalid level
    
    periscope:::logReset()
    expect_equal(periscope:::setLevel("INVALID"), loglevels["NOTSET"]) # invalid level
})

test_that("Levels in Logger object- setLevel() and getLevel()", {
    periscope:::logReset()
    log <- periscope:::getLogger("testLogger")
    
    # invalid level
    log$setLevel(150) 
    expect_equal(log$getLevel(), loglevels["NOTSET"])
    
    log$setLevel(TRUE) 
    expect_equal(log$getLevel(), loglevels["NOTSET"])
    
    log$setLevel("INVALID")
    expect_equal(log$getLevel(), loglevels["NOTSET"])
})

test_that("UpdateOptions - updateOptions()", {
    periscope:::logReset()
    periscope:::basicConfig()
    
    periscope:::updateOptions("", level = "WARN")
    expect_equal(periscope:::getLogger()$getLevel(), loglevels["WARN"])
})

test_that("LoggingToConsole", {
    periscope:::logReset()
    periscope:::basicConfig()
    
    periscope:::getLogger()$setLevel("FINEST")
    periscope:::addHandler(writeToConsole, level = "DEBUG")
    
    expect_equal(with(periscope:::getLogger(), names(handlers)), c("basic.stdout", "writeToConsole"))
    logdebug("log generated for testing")
    loginfo("log generated for testing")
    
    succeed()
})

test_that("LoggingToFile", {
    periscope:::logReset()
    unlink(test_file_name, force = TRUE)
    
    periscope:::getLogger()$setLevel("FINEST")
    periscope:::addHandler(writeToFile, file = test_file_name[[1]], level = "DEBUG")
    
    expect_equal(with(periscope:::getLogger(), names(handlers)), c("writeToFile"))
    logerror("log generated for testing")
    logwarn("log generated for testing")
    loginfo("log generated for testing")
    logdebug("log generated for testing")
    periscope:::logfinest("log generated for testing")
    periscope:::logfiner("log generated for testing")
    periscope:::logfine("log generated for testing")
    periscope:::levellog("log generated for testing")
    
    succeed()
})

test_that("LoggingToFile in Logger object", {
    periscope:::logReset()
    unlink(test_file_name, force = TRUE)
    
    log <- periscope:::getLogger()
    log$setLevel("FINEST")
    log$addHandler(writeToFile, file = test_file_name[[1]], level = "DEBUG")
    expect_equal(with(log, names(handlers)), c("writeToFile"))
    
    log$error("log generated for testing")
    log$warn("log generated for testing")
    log$info("log generated for testing")
    log$debug("log generated for testing")
    log$finest("log generated for testing")
    log$finer("log generated for testing")
    log$fine("log generated for testing")
    
    succeed()
})

test_that("Msgcomposer - setMsgComposer(), resetMsgComposer()", {
    env <- env_setup()
    
    periscope:::setMsgComposer(function(msg, ...) { paste(msg, "comp") })
    loginfo("test")
    
    expect_equal(env$logged, "INFO::test comp")
    expect_error(periscope:::setMsgComposer(function(msgX, ...) { paste(msg, "comp") }), 
                 regexp = "message composer(passed as composer_f) must be function  with signature function(msg, ...)",
                 fixed = TRUE)
    expect_error(periscope:::setMsgComposer(container = NULL), 
                 regexp = "NULL container provided: cannot set message composer for NULL container")
    
    # reset_composer
    env <- env_setup()
    periscope:::resetMsgComposer()
    loginfo("test")
    
    expect_equal(env$logged, "INFO::test")
    expect_error(periscope:::resetMsgComposer(NULL),
                 regexp = "NULL container provided: cannot resset message composer for NULL container")
    
    # set_sublogger_composer
    env <- env_setup()
    
    periscope:::setMsgComposer(function(msg, ...) { paste(msg, "comp") }, container = "named")
    loginfo("test")
    loginfo("test", logger = "named")
    
    expect_equal(env$logged, c("INFO::test", "INFO:named:test comp"))
})

test_that("MsgComposer function - defaultMsgCompose()",{
    expect_equal(periscope:::defaultMsgCompose(msg = "Message"), "Message")
    expect_error(periscope:::defaultMsgCompose(msg = paste(rep(LETTERS, 316), collapse = ""), param = 1), 
                 "'msg' length exceeds maximal format length 8192")
    expect_equal(periscope:::defaultMsgCompose(msg = paste(rep(LETTERS, 316), collapse = "")), 
                 paste(rep(LETTERS, 316), collapse = ""))
})
