//
//  CreateNewWordController.swift
//  イメージ単語カード
//
//  Created by 青山聡一郎 on 2018/01/23.
//  Copyright © 2018年 S.Aoyama. All rights reserved.
//

import UIKit
import RealmSwift
import Photos

class CreateNewWordController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 編集モード用のキーワード
    var keyWord = "";
    // 編集モード
    var isEdit = false
    
    var imageUrl:NSURL? = nil;
    // 単語
    @IBOutlet weak var word: UITextField!
    
    // 訳1~3
    @IBOutlet weak var translation1: UITextField!
    @IBOutlet weak var translation2: UITextField!
    @IBOutlet weak var translation3: UITextField!
    
    // 画像
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView.image = UIImage(named: "icon_new_create")
        
        // 編集モード
        if self.isEdit {
            // 単語欄は入力不可
            word.isEnabled = false
            
            // Realmからデータ取得
            let realm = try! Realm()
            let wordData = realm.object(ofType: WordData.self, forPrimaryKey: self.keyWord)
            
            // 各項目を設定
            self.word.text = wordData?.wordName
            self.translation1.text = wordData?.translation1
            self.translation2.text = wordData?.translation2
            self.translation3.text = wordData?.translation3
            
            // URLを作成
            if !(wordData?.imageUrl.isEmpty)! {
                let url = URL(string: (wordData?.imageUrl)!)!
                
                // Photo Libraryを使用してURLから写真を取得
                let fetchResult: PHFetchResult = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
                if fetchResult.count != 0 {
                    let asset: PHAsset = fetchResult.firstObject!
                    let manager = PHImageManager.default()
                    manager.requestImage(for: asset, targetSize: CGSize(width: 140, height: 140), contentMode: .aspectFill, options: nil) { (image, info) in
                        // imageをセットする
                        self.imageView.image = image
                    }
                }
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画像選択ボタン押下時の処理
    @IBAction func pickUpImage(_ sender: Any) {
        // カメラロールが利用可能か？
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            // 写真を選ぶビュー
            let pickerView = UIImagePickerController()
            // 写真の選択元をカメラロールにする
            // 「.camera」にすればカメラを起動できる
            pickerView.sourceType = .photoLibrary
            // デリゲート
            pickerView.delegate = self
            // ビューに表示
            self.present(pickerView, animated: true)
        }
    }
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if info[UIImagePickerControllerOriginalImage] != nil {
            self.imageUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
        }
        
        // ビューに表示する
        self.imageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
        
    
    // キャンセルボタン
    @IBAction func cancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
    
    // 保存ボタン
    @IBAction func saveButton(_ sender: Any) {
        
        let realm = try! Realm()
        
        let beforeWordData = realm.object(ofType: WordData.self, forPrimaryKey: self.word.text!)
        
        // 空白文字列のチェック
        if ( self.word.text?.isEmpty )!{
            self.showAlert( titleParam:"単語は必須項目です", messageParam:"単語欄には空白を設定できません" );
            return;
        }
        
        // 一意制約違反のチェック(新規の場合のみ）
        if beforeWordData != nil && !isEdit {
            self.showAlert( titleParam:"単語が重複しています", messageParam:"すでに設定されている単語です" );
            return;
        }
        
        //登録dataの作成
        let word = WordData()
        word.wordName = self.word.text!;
        word.translation1 = self.translation1.text!;
        word.translation2 = self.translation2.text!;
        word.translation3 = self.translation3.text!;
        if self.imageUrl != nil {
            word.imageUrl = (self.imageUrl?.absoluteString)!
        }else{
            if beforeWordData != nil {
                word.imageUrl = (beforeWordData?.imageUrl)!
            }
        }

        
        if !isEdit {
            try! realm.write {
                realm.add(word)
            }
        } else {
            try! realm.write {
                realm.add(word,update: true)
            }
        }
        
        // 画面を閉じる
        let view = storyboard?.instantiateViewController(withIdentifier: "lisViewContoller") as! ViewController
        present(view, animated: true, completion: nil);
    }
    
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
    
}
