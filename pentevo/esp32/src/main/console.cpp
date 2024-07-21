
#include <stdio.h>
#include <string.h>
#include "esp_system.h"
#include "esp_console.h"
#include "esp_log.h"
#include "esp_vfs_dev.h"
#include "driver/uart.h"
#include "linenoise/linenoise.h"
// #include "argtable3/argtable3.h"
// #include "freertos/FreeRTOS.h"
// #include "freertos/task.h"

#define PROMPT_STR    "zifi32"
const char* prompt;

void initialize_nvs(void)
{
  esp_err_t err = nvs_flash_init();

  if (err == ESP_ERR_NVS_NO_FREE_PAGES || err == ESP_ERR_NVS_NEW_VERSION_FOUND)
  {
    ESP_ERROR_CHECK(nvs_flash_erase());
    err = nvs_flash_init();
  }
  ESP_ERROR_CHECK(err);
}

void console_register_commands()
{
  esp_console_register_help_command();
  esp_console_register_system_commands();
  esp_console_register_wifi_commands();
}

void initialize_console()
{
  // Drain stdout before reconfiguring it
  fflush(stdout);
  fsync(fileno(stdout));

  // Disable buffering on stdin
  setvbuf(stdin, NULL, _IONBF, 0);

  // Minicom, screen, idf_monitor send CR when ENTER key is pressed
  esp_vfs_dev_uart_port_set_rx_line_endings(CONFIG_ESP_CONSOLE_UART_NUM, ESP_LINE_ENDINGS_CR);
  // Move the caret to the beginning of the next line on '\n'
  esp_vfs_dev_uart_port_set_tx_line_endings(CONFIG_ESP_CONSOLE_UART_NUM, ESP_LINE_ENDINGS_CRLF);

  // Install UART driver for interrupt-driven reads and writes
  ESP_ERROR_CHECK(uart_driver_install(CONFIG_ESP_CONSOLE_UART_NUM, 256, 0, 0, NULL, 0));

#if 0   // This makes a glitch. UART is already configured anyway
  // Configure UART. Note that REF_TICK is used so that the baud rate remains
  // correct while APB frequency is changing in light sleep mode.
  const uart_config_t uart_config =
  {
    .baud_rate = CONFIG_ESP_CONSOLE_UART_BAUDRATE,
    .data_bits = UART_DATA_8_BITS,
    .parity    = UART_PARITY_DISABLE,
    .stop_bits = UART_STOP_BITS_1,
#if SOC_UART_SUPPORT_REF_TICK
    .source_clk = UART_SCLK_REF_TICK,
#elif SOC_UART_SUPPORT_XTAL_CLK
    .source_clk = UART_SCLK_XTAL,
#endif
  };

  ESP_ERROR_CHECK(uart_param_config(CONFIG_ESP_CONSOLE_UART_NUM, &uart_config));
#endif

  // Tell VFS to use UART driver
  esp_vfs_dev_uart_use_driver(CONFIG_ESP_CONSOLE_UART_NUM);

  // Initialize the console
  esp_console_config_t console_config =
  {
    .max_cmdline_length = 256,
    .max_cmdline_args   = 8,
#if CONFIG_LOG_COLORS
    .hint_color         = atoi(LOG_COLOR_CYAN)
#endif
  };
  ESP_ERROR_CHECK(esp_console_init(&console_config));

  // Configure linenoise line completion library
  // Enable multiline editing. If not set, long commands will scroll within single line.
  linenoiseSetMultiLine(1);

  // Tell linenoise where to get command completions and hints
  linenoiseSetCompletionCallback(&esp_console_get_completion);
  linenoiseSetHintsCallback((linenoiseHintsCallback*)&esp_console_get_hint);

  // Set command history size
  linenoiseHistorySetMaxLen(100);

  // Set command maximum length
  linenoiseSetMaxLineLen(console_config.max_cmdline_length);

  // Don't return empty lines
  linenoiseAllowEmpty(false);

  // Register commands
  console_register_commands();

  // Prompt to be printed before each line.
  // This can be customized, made dynamic, etc.
  prompt = LOG_COLOR_I PROMPT_STR "> " LOG_RESET_COLOR;
}

void console_task(void *arg)
{
  _delay_ms(30);

  printf("\n"
         "Type 'help' to get the list of commands.\n"
         "Use UP/DOWN arrows to navigate through command history.\n"
         "Press TAB when typing command name to auto-complete.\n");

  while (true)
  {
    // Get a line using linenoise.
    // The line is returned when ENTER is pressed.
    char* line = linenoise(prompt);

    if (line == NULL) // Break on EOF or error
      continue;

    // Add the command to the history if not empty
    if (strlen(line) > 0)
      linenoiseHistoryAdd(line);

    // Try to run the command
    int       ret;
    esp_err_t err = esp_console_run(line, &ret);

    if (err == ESP_ERR_NOT_FOUND)
      printf("Unrecognized command\n");
    else if (err == ESP_ERR_INVALID_ARG)
    {
    }
    // command was empty
    else if (err == ESP_OK && ret != ESP_OK)
      printf("Command returned non-zero error code: 0x%x (%s)\n", ret, esp_err_to_name(ret));
    else if (err != ESP_OK)
      printf("Internal error: %s\n", esp_err_to_name(err));

    // linenoise allocates line buffer on the heap, so need to free it
    linenoiseFree(line);
  }
}
