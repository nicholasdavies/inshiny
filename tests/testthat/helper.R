cc = function(x) {
    cat(as.character(x))
}

fake_session = structure(
    list(
        input = list(select = "a"),
        sendCustomMessage = function(type, message) x <<- message
    ), class = "MockShinySession")
