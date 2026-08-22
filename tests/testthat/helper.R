cc = function(x) {
    cat(as.character(x))
}

# The id is recorded alongside the message so that tests can check both
fake_session = structure(
    list(
        input = list(select = "a"),
        sendInputMessage = function(inputId, message) x <<- c(list(id = inputId), message)
    ), class = "MockShinySession")
