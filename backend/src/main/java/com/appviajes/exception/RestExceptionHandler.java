package com.appviajes.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class RestExceptionHandler {

  @ExceptionHandler(Exception.class)
  public ResponseEntity<Void> handleRuntimeException(RuntimeException ex) {
    return ResponseEntity.internalServerError().build();
  }

  @ExceptionHandler(RestException.class)
  public ResponseEntity<Void> handleRuntimeException(RestException ex) {
    return ResponseEntity.status(ex.getErrorEnum().getStatus()).build();
  }
}