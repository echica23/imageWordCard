//
//  DispWordController.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/26.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class DispWordController: UIViewController {
    
    var keyWord = ""
    var dispWordsArray = [String]()
    var isImageMissing = false
    
    @IBOutlet weak var word: UILabel!
    
    @IBOutlet weak var translation1: UILabel!
    @IBOutlet weak var translation2: UILabel!
    @IBOutlet weak var translation3: UILabel!
    
    // 画像表示
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        
        //RealmからWordDataを取得
        let realm = try! Realm()
        let wordData = realm.object(ofType: WordData.self, forPrimaryKey: self.keyWord)
        
        // 各項目に設定
        self.word.text = wordData?.wordName
        self.translation1.text = wordData?.translation1;
        self.translation2.text = wordData?.translation2;
        self.translation3.text = wordData?.translation3;
        
        // 設定されていない訳はグレーに
        if (self.translation1.text?.isEmpty)! {
            self.translation1.backgroundColor = UIColor.lightGray
        }
        if (self.translation2.text?.isEmpty)! {
            self.translation2.backgroundColor = UIColor.lightGray
        }
        if (self.translation3.text?.isEmpty)! {
            self.translation3.backgroundColor = UIColor.lightGray
        }
        
        
        // URLを作成
        if !(wordData?.imageUrl.isEmpty)! {
            let url = URL(string: (wordData?.imageUrl)!)!
            print(url)

    //        let assets: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
    //        print(assets.count)
            
            // Photo Libraryを使用してURLから写真を取得
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            
            if fetchResult.count != 0 {
                let asset: PHAsset = fetchResult.firstObject!
                let manager = PHImageManager.default()
                manager.requestImage(for: asset, targetSize: CGSize(width: 140, height: 140), contentMode: .aspectFill, options: nil) { (image, info) in
                // imageをセットする
                self.imageView.image = image
                }
            }else{
                //画像が削除されたか移動された
                isImageMissing = true
            }
        }
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Exitボタン
    @IBAction func exitButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // Editボタン
    @IBAction func editButton(_ sender: Any) {
        
        let view = storyboard?.instantiateViewController(withIdentifier: "createNewWordController") as! CreateNewWordController
        view.isEdit = true
        view.keyWord = self.keyWord
        present(view, animated: true, completion: nil);
        
    }
    
    @IBAction func DispTranslationButton(_ sender: UIButton) {
        sender.isHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isImageMissing {
            self.showAlert( titleParam:"画像が見つかりません", messageParam:"すでに削除された画像です。編集から再度設定してください" );
        }
        
        super.viewDidAppear(animated)
    }
    
    // アラート表示
    func showAlert(titleParam:String, messageParam:String) {
        
        // アラートを作成
        let alert = UIAlertController(
            title: titleParam,
            message: messageParam,
            preferredStyle: .alert)
        
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    
    // 次の単語
    @IBAction func forward(_ sender: Any) {
        
        //現在の単語のindexを取得
        let index = dispWordsArray.index(of: keyWord)
        let count = dispWordsArray.count;
        
        print(count)
        print(index!)
        
        if  count == (index!+1) {
            // TODO
        } else {
            keyWord = dispWordsArray[index! + 1]
            print(keyWord)
            loadView();
            viewDidLoad()
        }
        
    }
    
    // 前の単語
    @IBAction func back(_ sender: Any) {
        
        //現在の単語のindexを取得
        let index = dispWordsArray.index(of: keyWord)
        let count = dispWordsArray.count;
        
        print(count)
        print(index!)
        
        if  index! == 0 {
            // TODO
        } else {
            keyWord = dispWordsArray[index! - 1]
            print(keyWord)
            loadView();
            viewDidLoad()
        }
        
        
    }
    
    
    
}
