package com.appviajes.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class RestExceptionHandler {

  @ExceptionHandler(RuntimeException.class)
  public ResponseEntity<String> handleRuntimeException(RuntimeException ex) {
    ex.printStackTrace(); // Muestra el stacktrace en consola
    return ResponseEntity.internalServerError().body("Error interno: " + ex.getMessage());
  }

  @ExceptionHandler(RestException.class)
  public ResponseEntity<String> handleRestException(RestException ex) {
    ex.printStackTrace();
    return ResponseEntity
        .status(ex.getErrorEnum().getStatus())
        .body("Error: " + ex.getMessage());
  }
}
