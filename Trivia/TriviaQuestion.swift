import Foundation

struct TriviaQuestion: Decodable {
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String // Updated key to match JSON response
    let incorrectAnswers: [String]
}

struct TriviaAPIResponse: Decodable {
    let responseCode: Int
        let results: [TriviaQuestion]

        private enum CodingKeys: String, CodingKey {
            case responseCode
            case results
        }
    
}

class TriviaQuestionService {
    static func fetchTriviaQuestions(completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=7") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? NSError(domain: "Unknown error", code: -1, userInfo: nil)))
                return
            }
            
            do {
                print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to parse data")")
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase // Use snake_case decoding strategy
                let response = try decoder.decode(TriviaAPIResponse.self, from: data)
                print("Decoded response: \(response)")
                if response.responseCode == 0 {
                    print("Number of questions received: \(response.results.count)")
                    completion(.success(response.results))
                } else {
                    completion(.failure(NSError(domain: "Trivia API Error", code: response.responseCode, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}



