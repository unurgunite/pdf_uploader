# PdfUploader

_Honestly, I don't know why I have to name this project as it is now._

This project is a personal Ruby Telegram Bot which could help you to store links from "Index of" resources.

## Documentation content

1. [Overview][1]
2. [Installation][2]
3. [Usage][3]
    1. [Commands][3.1]
4. [Todo][4]
5. [Requirements][5]
6. [Contributing][6]
7. [License][7]
8. [Code of Conduct][8]

## Overview

This project could help you to store files from "Index of" resources inside Telegram.

## Installation

Firstly, you'll need Ruby 2.7 or above (but I think it will work on legacy versions too). I recommend to use rbenv to
manage your Rubies.

After building Ruby install the project and download dependencies:

```shell
git clone https://github.com/unurgunite/pdf_uploader.git && \
cd pdf_uploader && \
bundle install
```

If everything downloaded without any errors, go to [BotFather](https://t.me/BotFather) to get Telegram API token. We
should store it somewhere, so create a file `.env` at project's root as below:

```shell
echo 'TELEGRAM_TOKEN=YOUR-TOKEN-HERE' > .env
```

## Usage

Now everything should work fine. Type in your terminal:

```shell
bundle exec ruby main.rb
```

And follow to your bot.

### Commands

Here is a table with common commands which bot could serve.

| Commands      | Description                           |
|---------------|---------------------------------------|
| `/start`      | Start the bot                         |
| `/upload_url` | Upload url to get files from resource |
| `/help`       | Print all commands                    |

## TODO

The current parser implementation does not support links other than in "Index of" format, so I would be glad to receive
a support.

## Requirements

Here is a table showing all dependencies for this project.

| Dependencies                                                       | Description                                                                                   |
|--------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) | A library for communication with Telegram Bot API                                             |
| [nokogiri](https://github.com/sparklemotion/nokogiri)              | A library for parsing and analyzing XML sources                                               |
| [httparty](https://github.com/jnunemaker/httparty)                 | A library for making requests easily (than via [Net::HTTP](https://github.com/ruby/net-http)) |
| [dotenv](https://github.com/bkeepers/dotenv)                       | A library for storing sensitive information (API token, for e.g.)                             |
| [rbs](https://github.com/ruby/rbs)                                 | A library for creating a type signatures (**ONLY FOR DEVELOPMENT!**)                          |
| [debug](https://github.com/ruby/debug)                             | A library for debugging Ruby code evaluating (**ONLY FOR DEVELOPMENT!**)                      |
| [rubocop](https://github.com/rubocop/rubocop)                      | A library for code cleaning (**ONLY FOR DEVELOPMENT!**)                                       |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/unurgunite/pdf_uploader. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to
the [code of conduct](https://github.com/unurgunite/pdf_uploader/blob/master/CODE_OF_CONDUCT.md). To contribute you
should
fork this project and create there new branch:

```shell
git clone https://github.com/your-beautiful-username/pdf_uploader.git && \
git checkout -b refactor && \
git commit -m "Affected new changes" && \
git push origin refactor
```

And then make new pull request with additional notes of what you have done. The better the changes are scheduled, the
faster the PR will be checked.

## Code of Conduct

Everyone interacting in the `PdfUploader` project's codebases, issue trackers, chat rooms and mailing lists is expected
to follow the [code of conduct](https://github.com/unurgunite/pdf_uploader/blob/master/CODE_OF_CONDUCT.md).

## License

The project is available as open source under the terms of
the [3-Clause BSD License](https://opensource.org/licenses/bsd-3-clause). The copy of the license is stored in project
under the `LICENSE.txt` file
name: [copy of the License](https://github.com/unurgunite/pdf_uploader/blob/master/LICENSE.txt)

The documentation is available as open source under the terms of
the [CC BY-SA 4.0 License](https://creativecommons.org/licenses/by-sa/4.0/)

![CC BY-SA 4.0](https://mirrors.creativecommons.org/presskit/buttons/88x31/svg/by-nc.svg)
![BSD license logo](https://upload.wikimedia.org/wikipedia/commons/4/42/License_icon-bsd-88x31.png)

[1]:https://github.com/unurgunite/pdf_uploader#overview

[2]:https://github.com/unurgunite/pdf_uploader#installation

[3]:https://github.com/unurgunite/pdf_uploader#usage

[3.1]:https://github.com/unurgunite/pdf_uploader#commands

[4]:https://github.com/unurgunite/pdf_uploader#todo

[5]:https://github.com/unurgunite/pdf_uploader#requirements

[6]:https://github.com/unurgunite/pdf_uploader#contributing

[7]:https://github.com/unurgunite/pdf_uploader#license

[7]:https://github.com/unurgunite/pdf_uploader#license

[8]:https://github.com/unurgunite/genius-api#code-of-conduct
