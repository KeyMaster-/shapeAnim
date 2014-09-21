package shapeanim.styles;
import haxe.ds.IntMap;

class StylePack {
	public var fillStyles:IntMap<IFillStyle>;
	public var lineStyles:IntMap<ILineStyle>;
	public function new() {
		fillStyles = new IntMap<IFillStyle>();
		lineStyles = new IntMap<ILineStyle>();
	}
}