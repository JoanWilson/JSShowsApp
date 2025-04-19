# JSShowsApp

JSShowsApp is an iOS application that helps users discover and explore TV shows. The app provides a clean and intuitive interface for browsing popular shows, searching for specific titles, and viewing detailed information about each show.

## Features

- Browse popular TV shows
- Search for specific shows by title
- View detailed information about each show including:
  - Synopsis
  - Cast information
  - Episode guides
  - Rating and air dates
- Save favorite shows for quick access
- Clean and responsive UI built with Swift and UIKit

## Screenshots
<div style="display: flex; justify-content: space-around; align-items: center;">
  <img src="https://github.com/user-attachments/assets/eca6a2b2-8e7f-4b8c-9c04-3cce8a890734" alt="Screenshot 1" width="30%">
  <img src="https://github.com/user-attachments/assets/71bf842c-e270-4f76-93fe-f6a5fa9413cc" alt="Screenshot 2" width="30%">
  <img src="https://github.com/user-attachments/assets/4ed24f2f-9919-4fec-997e-14c4016fa320" alt="Screenshot 3" width="30%">
</div>

## Requirements

- iOS 14.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/JoanWilson/JSShowsApp.git
   ```

2. Navigate to the project directory:
   ```bash
   cd JSShowsApp
   ```

3. Open the project in Xcode:
   ```bash
   open JSShowsApp.xcodeproj
   ```

4. Build and run the project using Xcode's simulator or on a physical device.

## Architecture

JSShowsApp follows the MVVM (Model-View-ViewModel) architecture pattern, with a clean separation of concerns:

- **Models**: Data structures that represent TV shows and related information
- **Views**: UIKit components that display the UI
- **ViewModels**: Classes that handle business logic and prepare data for display
- **Services**: Components that handle networking, data persistence, and other infrastructure concerns

## APIs

This app uses the [TVMaze API](https://www.tvmaze.com/api) to fetch show data.

## Dependencies

The project uses the following dependencies:

- UIKit for the user interface
- URLSession for networking
- CoreData for data persistence

## Future Enhancements

- Add user authentication
- Implement show recommendations based on viewing history
- Add support for tracking watched episodes
- Create custom watch lists

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

- **Joan Wilson** - [GitHub Profile](https://github.com/JoanWilson)

## Acknowledgements

- [TVMaze API](https://www.tvmaze.com/api) for providing the TV show data
- All the open source libraries used in this project
