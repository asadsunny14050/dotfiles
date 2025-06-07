#include <stdio.h>
#include <string.h>

void log_shit(char *text, char *arg) {
  size_t log_size = strlen(text) + 100;
  char log_buffer[log_size];

  snprintf(log_buffer, log_size, text, arg);
  printf("[%s] %s [%s]\n", "bhau", log_buffer, "bhau");
}

int main() {
  int x = 0;
  log_shit("the dog %s is sick", "bruno");
}

int add(int a, int b) { return a + b; }
