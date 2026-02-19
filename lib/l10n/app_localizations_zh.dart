// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '扫墓通';

  @override
  String get addPersonTitle => '添加新人物';

  @override
  String get nameLabel => '姓名';

  @override
  String get nameHint => '请输入长辈或亲友姓名';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get addRelationship => '添加新关系';

  @override
  String get selectTarget => '选择目标人物';

  @override
  String get relationshipLabel => '关系名称';

  @override
  String get saveAndConnect => '保存并连接';

  @override
  String detailTitle(String name) {
    return '$name 的详细信息';
  }

  @override
  String get addStepTitle => '添加指引步骤';

  @override
  String get stepDescHint => '描述详细路线';

  @override
  String get tapToTakePhoto => '点击拍照';

  @override
  String get add => '添加';

  @override
  String routeToName(String name) {
    return '前往 $name 的路线';
  }

  @override
  String get noRouteRecords => '还没有记录路线\n点击右下角开始记录';

  @override
  String get recordNewLandmark => '记录新路标';

  @override
  String get upload_photo => '更换图片';

  @override
  String get nameinfo => '姓名';

  @override
  String get birthDateHint => '生辰';

  @override
  String get deathDateHint => '祭日';

  @override
  String get biography => '生平';

  @override
  String get last_mile_navigation_description1 => '最后一公里指引';

  @override
  String get last_mile_navigation_description2 => '记录寻找墓地的图文路标';

  @override
  String get error_adding_connection_without_others =>
      '需要先在主地图添加其他人物，才能在这里建立关系。';

  @override
  String get relationshipLabelHint => ' (如：师生、父子)';

  @override
  String get input_select_target => '请选择一个目标人物';

  @override
  String get input_relationship_label => '请输入关系名称';

  @override
  String get build_connection_success => '关系添加成功';

  @override
  String get cameraLabel => '拍照';

  @override
  String get galleryLabel => '从相册中选择';

  @override
  String get imagePickerErrorMessage => '选择图片出错';

  @override
  String get has_last_mile => '有路线';

  @override
  String get copyrightNotice =>
      '本软件所有数据均加密或保存在您的本地设备中，未经您的允许不会上传至任何云端服务器，请妥善保管您的设备与数据备份。';

  @override
  String get softwareDescription => '———— 为纪念与传承而生';

  @override
  String get contactDeveloperLabel => '联系作者';

  @override
  String get developerEmail => 'passbyyyyy@gmail.com';

  @override
  String get storagePathLabel => '数据存储路径';

  @override
  String get versionLabel => '版本号: 1.1.0';

  @override
  String get infoScreenTitle => '关于本软件';

  @override
  String get copyToClipboardLabel => '成功复制至剪贴板';

  @override
  String get deleteNodeTooltip => '删除人物';

  @override
  String get deleteConfirmTitle => '确认删除?';

  @override
  String get deleteConfirmContent => '删除是不可逆的，此人物的所有信息都将会被删除: ';

  @override
  String get confirmDelete => '删除';

  @override
  String get connection => '关系';

  @override
  String get unknownPerson => '未知人员';

  @override
  String get deleteConnectionTooltip => '解除关系';

  @override
  String get connectionDeletedSuccessfully => '已解除';

  @override
  String get noConnectionsTip => '该人物暂时没有和他人有连线，请先添加。';
}
