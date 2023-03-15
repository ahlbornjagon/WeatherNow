import Foundation
import CoreLocation


protocol WeatherManagerDelegate {
        func didUpdateWeather(_ weatherManager: WeatherManager, Weather: WeatherModel)
        func didFailWithError(error: Error)

    }
struct WeatherManager{
    
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=c24dce0256e8c1174f148d9b9e234cf4&units=imperial"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        print("Starting fetch")
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude:CLLocationDegrees,longitude:CLLocationDegrees ){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String){
        //Step 1: Create URL

        if let url = URL(string: urlString){
            //Step 2: Create a URL Session
            
            let session = URLSession(configuration: .default)
            
            //Step 3: Give the session a data task
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
            }

            if let safeData = data {
                if let weather = self.parseJSON(safeData){
                    delegate?.didUpdateWeather(self, Weather: weather)
                    
                }
                }
            }
            //Step 4: Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self , from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            
            
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
    
   
    
}
