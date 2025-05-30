/* Author: Jacob Clarey
 * Instructor: Dr. Parikh
 * Date: 5/29/2025
 * Description:
 *
 * Notes:
 */

#include <stdio.h>
#include <stm32wb55xx.h>
#include <string.h>

volatile int gPasswordEntered = 0;
void addToHtml(const char *str) {
  // Function to display string to user's web browser.
  // Just a stub since this is not important.
  ;
}

void printUserWelcome(const char *userName, unsigned userNameLength) {
  char buf[50] = "Welcome to the web site, ";
  // EXTRA CREDIT: Why can't you use strcat() and omit
  // the userNameLength parameter?
  memcpy(buf + strlen(buf), userName, userNameLength);
  addToHtml(buf);
  gPasswordEntered = 0; // Indicate user needs to enter a password
}

int main(void) {
  printUserWelcome("Harold", 6);
  if (gPasswordEntered == 1) {
    printf("Success");
    fflush(stdout);
  } else {
    printf("Failed");
    fflush(stdout);
  }
  while (1) {
  }
}

/* EOF */
