# Project 4 - *Trivia App pt2*

Submitted by: **Maneesha**

**Trivia App** is an app that **Trivia** is an app that app that displays a question and 4 choices.A user can view the current question and 4 different answers where they can navigate to  the next question after tapping on an any option. User can track which question they're currently and how many questions they got correct after they've answered all the questions. When  User restarts the game after they've finished answering all questions, different set of questions are generated. User should can view answer 7 trivia questions with  a max of 4 different possible answers and True or False questions only have two options. While answering each question feedback whether each question answered was correct or incorrect will be generated before navigating to the next.

Time spent: **5** hours spent in total

## Required Features

The following **required** functionality is completed:

- [x] User can view and answer at least 5 trivia questions.
- [x] App retrieves question data from the Open Trivia Database API.
- [x] Fetch a different set of questions if the user indicates they would like to reset the game.
- [x] Users can see score after submitting all questions.
- [x] True or False questions only have two options.


The following **optional** features are implemented:

  
- [ ] Allow the user to choose a specific category of questions.
- [x] Provide the user feedback on whether each question was correct before navigating to the next.

The following **additional** features are implemented:

- [ ] List anything else that you can get done to improve the app functionality!

## Video Walkthrough
 <div>
    <a href="https://www.loom.com/share/fdf33917b23a4f77b95a645f6e43baeb">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/fdf33917b23a4f77b95a645f6e43baeb-with-play.gif">
    </a>
  </div>

## Notes

Challenges encountered while building the app.

- Parsing logic for the APIResponse, understanding JSON structure and Using snake_case decoding strategy
- Understanding NSAttributedString class, which provides a method for decoding HTML entities Concept
- decoding the reason for  "Index out of range" Error, which is currQuestionIndex being incremented beyond the number of questions available 
  in the questions array.



## License

    Copyright [2024] [Maneesha007]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
