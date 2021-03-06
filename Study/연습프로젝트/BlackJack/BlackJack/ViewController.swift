//
//  ViewController.swift
//  BlackJack
//
//  Created by 박상욱 on 2018. 2. 15..
//  Copyright © 2018년 sangwook park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //객체 생성
    var background : BackImg!
    var user : Card!
    var diller : Card!
    var userName : DisplayStatus!
    var dillerName : DisplayStatus!
    var resultLB : DisplayStatus!
    var userBtn : DisplayButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //BlackJack Game Create
        create()
    }

    func create() {
        //백그라운드 이미지 로드
        background = BackImg(frame: self.view.bounds)
        view.addSubview(background)
        
        //유저 카드 초기화 및 프레임 설정
        user = Card(frame: CGRect(x: (view.bounds.width / 2) - 195, y: view.bounds.height - 150, width: 390, height: 100), diller: false)
        self.view.addSubview(user)
        
        //유저 상태창 초기화 및 프레임 설정
        userName = DisplayStatus(frame: CGRect(x: 0, y: view.bounds.height - 195, width: view.bounds.width, height: 50), name: "User")
        self.view.addSubview(userName)
        
        //딜러 카드 초기화 및 프레임 설정
        diller = Card(frame: CGRect(x: (view.bounds.width / 2) - 195, y: 50, width: 390, height: 100), diller: true)
        self.view.addSubview(diller)
        
        //딜러 상태창 초기화 및 프레임 설정
        dillerName = DisplayStatus(frame: CGRect(x: 0, y: diller.frame.maxY + 15, width: view.bounds.width, height: 50), name: "Diller")
        self.view.addSubview(dillerName)
        
        //중앙 레이블 초기화 및 프레임 설정
        resultLB = DisplayStatus(frame: CGRect(x: (view.bounds.width / 2) - 150, y: (view.bounds.height / 2) - 150, width: 300, height: 300))
        resultLB.centerCreate()
        self.view.addSubview(resultLB)
        
        //Diplay Button 초기화 및 프레임 설정
        userBtn = DisplayButton(frame: CGRect(x: (view.bounds.width / 2) - 140, y: view.bounds.height - 205, width: 320, height: 50))
        self.view.addSubview(userBtn)
        
        //Button Event
        userBtn.hit.addTarget(self, action: #selector(self.clickHit(_:)), for: .touchUpInside)
        userBtn.stand.addTarget(self, action: #selector(self.clickStand(_:)), for: .touchUpInside)
        userBtn.reStart.addTarget(self, action: #selector(self.clickRestart(_:)), for: .touchUpInside)
    }
    
    
    /// Card Class의 cardCollection을 불러와서
    /// isSelected가 true인 카드의 카운트를 계산 해주는 함수
    /// - Parameter cards: Card Class
    /// - Returns: count
    func cardCounting(cards : Card) -> Int{
        var count : Int = 0
        var aceCount : Bool = false
        for card in cards.cardCollection {
            if card.isSelected {
                if card.tag == 1 {
                    aceCount = true
                }
                count += card.tag
            }
        }
        return count <= 11 && aceCount ? count + 10 : count
    }
    func blackJack(cards : Card) -> Bool {
        var count : Int = 0
        for card in cards.cardCollection {
            if card.isSelected {
                count += 1
            }
        }
        return count == 2 && cardCounting(cards: cards) == 21 ? true : false
    }
    
    /// 카드한장을 추가로 받아오며 받은 카드가 21이 넘을 때 Bust가 되므로
    /// 자동으로 clickStand 함수를 호출하여 결과를 호출
    /// - Parameter sender: Hit Button
    @objc func clickHit(_ sender : UIButton) {
        //카드가 순서 대로 오픈되기 때문에 isSelected상태가 false카드 한장을 true로 변경해준다.
        for card in user.cardCollection {
            if card.isSelected == false {
                card.isSelected = true
                break
            }
        }
        
        //user의 카드 카운트가 hit로 인해 21을 초과시에
        //bust상태이므로 자동으로 Stand로 넘겨주고 히트버튼을 비활성화한다
        if cardCounting(cards: user) > 21 {
            userBtn.hit.isUserInteractionEnabled = false
            self.clickStand(userBtn.stand)
        }
    }
    
    /// 유저의 카드 추가가 끝난 후 Stand 버튼을 누르면 발생하는 함수
    /// 1. 딜러의 카드카운팅이 17보다 작을 때 딜러도 카드를 추가한다
    /// 2. 마지막으로 딜러와 유저의 카드 카운팅을 비교하여 카운트가 높은 쪽이 승리하며 21을 넘어 갈 시에
    /// 3. bust상태가 되며 버스트 상태시에는 0점이 된다.(딜러도 마찬가지)
    /// 4. 이긴쪽의 카운팅이 21일 시에 블랙잭으로 이기면 BlackJack이 표시
    /// - Parameter sender: Stand Btn
    @objc func clickStand(_ sender : UIButton) {
        //userCount와 dillerCount를 담을 변수 추가
        var userCount : Int = 0
        var dillerCount : Int = 0
        
        //diller는 처음 두장을 받을 때 한장만을 보여주지만
        //user의 카드 추가가 끝나고 Stand를 눌렀을 때
        //딜러의 카드카운팅이 17보다 적을 시에 카드를 추가하고
        //결과를 보여주기 위해 모든 카드를 보여준다.
        for card in diller.cardCollection {
            if card.isSelected == false {
                card.isSelected = true
            }
            if cardCounting(cards: diller) >= 17 {
                break
            }
        }
        
        //user와 diller의 카운트 값을 구하고 22이보다 카운트가 높을시에 버스트상태로 변경시킨다.
        userCount = cardCounting(cards: user) < 22 ? cardCounting(cards: user) : 0
        dillerCount = cardCounting(cards: diller) < 22 ? cardCounting(cards: diller) : 0
        
//        UIView.animate(withDuration: 0.3,
//            animations: {
//
//
//        }) { (<#Bool#>) in
//            <#code#>
//        }
        
        //user와 diller의 카운트 값을 비교하고 중앙 레이블의 텍스트 값을 변경시켜서 승리의 유무와 블랙잭일시 알려준다.
        if  userCount < dillerCount && blackJack(cards: diller) {
            resultLB.centerLB.text =
                                        """
                                        Diller
                                        BlackJack !!
                                        """
        }
        else if userCount < dillerCount  {
            resultLB.centerLB.text = "Lose !!"
        }
        else if userCount > dillerCount && blackJack(cards: user) {
            resultLB.centerLB.text =
                                        """
                                        User
                                        BlackJack !!
                                        """
        }
        else if userCount > dillerCount {
            resultLB.centerLB.text = "Win !!"
        }
        else {
            resultLB.centerLB.text = "Draw !!"
        }
        
        //경기가 종료된 후에 버튼을 비활성화
        userBtn.hit.isUserInteractionEnabled = false
        userBtn.stand.isUserInteractionEnabled = false
    }
    
    
    //restart버튼을 누를 시 게임이 다시 시작된다.
    @objc func clickRestart(_ sender : UIButton) {
        self.create()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

